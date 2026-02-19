import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/asclepio_theme.dart';
import '../../widgets/health_components.dart';

class RunTrackerPage extends StatefulWidget {
  const RunTrackerPage({super.key});

  @override
  State<RunTrackerPage> createState() => _RunTrackerPageState();
}

class _RunTrackerPageState extends State<RunTrackerPage> {
  // Map Controller
  final MapController _mapController = MapController();

  // State
  bool _isTracking = false;
  bool _isPaused = false;
  final List<LatLng> _routePoints = [];
  LatLng? _currentPosition; // Nullable to indicate loading
  // Stats
  Timer? _timer;
  int _seconds = 0;
  double _distanceKm = 0;

  // Stream
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get initial position
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(pos.latitude, pos.longitude);
    });
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 16);
    }
  }

  void _toggleTracking() {
    if (_isTracking) {
      // Pause or Stop
      if (_isPaused) {
        // Resume
        _startStream();
        setState(() => _isPaused = false);
      } else {
        // Pause
        _positionStream?.pause();
        _timer?.cancel();
        setState(() => _isPaused = true);
      }
    } else {
      // Start
      setState(() {
        _isTracking = true;
        _seconds = 0;
        _distanceKm = 0;
        _routePoints.clear();
      });
      _startStream();
      _startTimer();
    }
  }

  void _startStream() {
    const settings =
        LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5);
    _positionStream = Geolocator.getPositionStream(locationSettings: settings)
        .listen((Position position) {
      final newPoint = LatLng(position.latitude, position.longitude);

      setState(() {
        if (_routePoints.isNotEmpty) {
          final dist = Geolocator.distanceBetween(
              _routePoints.last.latitude,
              _routePoints.last.longitude,
              newPoint.latitude,
              newPoint.longitude);
          _distanceKm += dist / 1000;
        }
        _routePoints.add(newPoint);
        _currentPosition = newPoint;
      });

      _mapController.move(newPoint, 17);
    });

    if (_isPaused) {
      _positionStream?.resume();
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _seconds++);
    });
  }

  void _stopRun() {
    _positionStream?.cancel();
    _timer?.cancel();

    if (_distanceKm > 0) {
      final paceVal = _distanceKm > 0 ? (_seconds / 60) / _distanceKm : 0.0;
      final calories = (_distanceKm * 60).toInt(); // Rough estimate

      final activityData = {
        'type': 'Run',
        'durationSeconds': _seconds,
        'distance': double.parse(_distanceKm.toStringAsFixed(2)),
        'pace': double.parse(paceVal.toStringAsFixed(2)),
        'calories': calories,
        'date': DateTime.now().toIso8601String(),
      };

      context.read<AppProvider>().addCardioActivity(activityData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Corrida salva com sucesso!'),
            backgroundColor: AsclepioTheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h > 0 ? '$h:' : ''}${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _calculatePace() {
    if (_distanceKm == 0) return '0:00';
    final paceSeconds = _seconds / _distanceKm;
    final m = paceSeconds ~/ 60;
    final s = (paceSeconds % 60).toInt();
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Map Layer ──────────────────────────────────────────────────────
          if (_currentPosition == null)
            const Center(child: CircularProgressIndicator())
          else
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                initialZoom: 16,
                interactionOptions:
                    const InteractionOptions(flags: InteractiveFlag.all),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.asclepio.app',
                  // Dark mode map filter matrix? For now standard OSM
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 5,
                      color: AsclepioTheme.primary,
                    ),
                  ],
                ),
                if (_isTracking &&
                    _routePoints
                        .isNotEmpty) // Only show marker if tracking and points exist
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                        width: 20,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AsclepioTheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: AsclepioTheme.shadowNeon,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

          // ── Top Overlay (Controls) ─────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: Colors.black87), // Assuming light map
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: _stopRun,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('GPS ATIVO', // Translated
                        style: TextStyle(
                            color: AsclepioTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                  // Settings icon
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          // ── Bottom Stats ───────────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).scaffoldBackgroundColor, // Changed color
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: AsclepioTheme.shadowNeon, // Changed boxShadow
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Grid Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statItem(
                          'Distância', _distanceKm.toStringAsFixed(2), 'km'),
                      _statItem('Tempo', _formatTime(_seconds), ''),
                      _statItem('Ritmo', _calculatePace(), 'min/km'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statItem(
                          'Calorias', '${(_distanceKm * 60).toInt()}', 'kcal'),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Actions
                  Row(
                    children: [
                      if (_isTracking)
                        Expanded(
                          child: GestureDetector(
                            onTap: _toggleTracking,
                            child: Container(
                              height: 64,
                              decoration: BoxDecoration(
                                color: _isPaused
                                    ? AsclepioTheme.primary
                                    : AsclepioTheme.secondary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                _isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                size: 36,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      else
                        Expanded(
                            child: GradientButton(
                                text: 'START RUN', onPressed: _toggleTracking)),
                      if (_isPaused) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: _stopRun,
                            child: Container(
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                  child: Text("FINISH",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, String unit) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(unit,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600)),
            ],
          ],
        ),
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'dart:async';

class NearbyHospitalsPage extends StatefulWidget {
  const NearbyHospitalsPage({super.key});

  @override
  State<NearbyHospitalsPage> createState() => _NearbyHospitalsPageState();
}

class _NearbyHospitalsPageState extends State<NearbyHospitalsPage> {
  Position? _userLocation;
  bool _loading = true;
  String? _locationError;
  final List<Marker> _markers = [];
  late MapController _mapController;
  final double searchRadius = 5000; // 5km (reduzido de 35km)
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      _loading = true;
      _locationError = null;
    });
    try {
      // Verificar e solicitar permissão de localização
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _loading = false;
          _locationError =
              'Permissão de localização negada permanentemente. Habilite nas configurações do dispositivo.';
        });
        return;
      }
      if (permission == LocationPermission.denied) {
        setState(() {
          _loading = false;
          _locationError = 'Permissão de localização negada.';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userLocation = position;
        _loading = false;
      });
      await _addNearbyHospitals(LatLng(position.latitude, position.longitude));
    } catch (e) {
      setState(() {
        _loading = false;
        _locationError = 'Erro ao obter localização: $e';
      });
    }
  }

  Future<void> _addNearbyHospitals(LatLng center) async {
    final double latitude = center.latitude;
    final double longitude = center.longitude;

    final String url =
        'https://overpass-api.de/api/interpreter?data=[out:json];node[amenity=hospital](around:$searchRadius,$latitude,$longitude);out;';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _markers.clear(); // Limpar os marcadores antes de adicionar novos
          for (var element in data['elements']) {
            final lat = element['lat'];
            final lon = element['lon'];
            final name = element['tags']['name'] ?? 'Hospital Desconhecido';
            final address =
                element['tags']['addr:full'] ?? 'Endereço desconhecido';
            final phone = element['tags']['phone'] ?? 'Telefone desconhecido';

            _markers.add(
              Marker(
                point: LatLng(lat, lon),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    _showHospitalDetails(
                        name, address, phone, lat, lon); // Passar lat e lon
                  },
                  child: const Icon(Icons.local_hospital,
                      color: Colors.red, size: 40),
                ),
              ),
            );
          }
        });
      } else {
        _showError('Erro ao obter dados dos hospitais',
            onRetry: () => _addNearbyHospitals(center));
      }
    } catch (e) {
      // print('Erro ao conectar com o servidor: $e'); // Logar o erro
      _showError('Erro ao conectar com o servidor',
          onRetry: () => _addNearbyHospitals(center));
    }
  }

  void _showHospitalDetails(
      String name, String address, String phone, double lat, double lon) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              Text('Endereço: $address'),
              Text('Telefone: $phone'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o BottomSheet
                  _launchMaps(lat, lon); // Usar lat e lon diretamente
                },
                child: const Text('Abrir no Google Maps'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchMaps(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _showError('Não foi possível abrir o Google Maps');
    }
  }

  void _showError(String message, {VoidCallback? onRetry}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              if (onRetry != null)
                TextButton(
                  child: const Text('Tentar Novamente'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRetry();
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _centerMap() {
    if (_userLocation != null) {
      _mapController.move(
          LatLng(_userLocation!.latitude, _userLocation!.longitude), 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitais e Clínicas Próximas'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _locationError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_off,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _locationError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _getUserLocation,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Tentar Novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(_userLocation?.latitude ?? 0,
                        _userLocation?.longitude ?? 0),
                    initialZoom: 15.0,
                    maxZoom: 18.0,
                    onMapEvent: (event) {
                      if (event is MapEventMove) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 500), () {
                          _addNearbyHospitals(_mapController.camera.center);
                        });
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(markers: _markers),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerMap,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

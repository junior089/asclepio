import 'package:flutter/material.dart';
import '../../theme/asclepio_theme.dart';
import '../activities/run_tracker_page.dart';

class CardioTrackingPage extends StatelessWidget {
  const CardioTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AsclepioTheme.backgroundDark, // Full screen immersive feel
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image (Placeholder)
          Opacity(
            opacity: 0.6,
            child: Image.network(
              // In production use asset
              'https://images.unsplash.com/photo-1502904550040-7534597429ae?q=80&w=1000&auto=format&fit=crop',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: Colors.grey[900]),
            ),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  const Positioned(
                      top: 0, left: 0, child: BackButton(color: Colors.white)),

                  const Spacer(),

                  const Text('OUTDOOR RUN',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 0.9,
                          letterSpacing: -2)),
                  const SizedBox(height: 16),
                  const Text(
                    'Track your pace, distance and route in real-time.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 40),

                  // Start Button
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AsclepioTheme.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RunTrackerPage())),
                      child: const Text('GO RUN',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

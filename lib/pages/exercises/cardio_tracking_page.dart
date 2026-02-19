import 'package:flutter/material.dart';
import '../../theme/asclepio_theme.dart';
import '../activities/run_tracker_page.dart';

class CardioTrackingPage extends StatelessWidget {
  const CardioTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AsclepioTheme.backgroundDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
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
                  const Spacer(),

                  const Text('CORRIDA\nAO AR LIVRE',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 0.9,
                          letterSpacing: -2)),
                  const SizedBox(height: 16),
                  const Text(
                    'Acompanhe seu ritmo, distância e rota em tempo real.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 40),

                  // Botão Iniciar
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AsclepioTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RunTrackerPage())),
                      child: const Text('INICIAR CORRIDA',
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

          // Botão voltar
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

import 'package:flutter/material.dart';

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  _StatCardState createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  double elevation = 4;
  bool isPressed = false; // Para controle de animação

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setElevation(2, true),
      onTapUp: (_) => _setElevation(4, false),
      onTapCancel: () => _setElevation(4, false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isPressed ? widget.color.withOpacity(0.1) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.4),
              blurRadius: elevation * 3,
              offset: Offset(0, elevation),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconContainer(),
              const SizedBox(height: 10),
              _buildTitleText(context),
              const SizedBox(height: 8),
              _buildValueText(context),
            ],
          ),
        ),
      ),
    );
  }

  void _setElevation(double newElevation, bool pressed) {
    setState(() {
      elevation = newElevation;
      isPressed = pressed; // Atualiza o estado de pressionado
    });
  }

  Widget _buildIconContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [widget.color.withOpacity(0.6), widget.color],
          center: Alignment.center,
          radius: 0.8,
        ),
      ),
      child: Icon(widget.icon, size: 50, color: Colors.white),
    );
  }

  Text _buildTitleText(BuildContext context) {
    return Text(
      widget.title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    );
  }

  Text _buildValueText(BuildContext context) {
    return Text(
      widget.value,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Colors.grey[600],
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

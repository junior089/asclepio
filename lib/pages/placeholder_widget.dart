import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final String title;

  const PlaceholderWidget(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

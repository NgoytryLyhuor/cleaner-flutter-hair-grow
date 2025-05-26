import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double size;

  const Loading({
    Key? key,
    this.size = 100.0, // Increased default size for GIF visibility
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size + 20, // Add some padding around the GIF
        height: size + 20,
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.4), // Dark background to contrast white GIF
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/frezka_loader.gif',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
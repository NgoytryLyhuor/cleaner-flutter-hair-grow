import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  final double size;

  const Loading({
    Key? key,
    this.size = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size + 20,
        height: size + 20,
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.4),
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
          child: Lottie.asset(
            'assets/lottie/app_loader.json',
            width: size,
            height: size,
            fit: BoxFit.contain,
            delegates: LottieDelegates(
              values: [
                ValueDelegate.color(
                  const ['**'], // You can target specific keypaths if known
                  value: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

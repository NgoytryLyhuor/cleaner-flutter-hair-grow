import 'package:flutter/material.dart';

class BookingHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const BookingHeader({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Option 1: Increase padding (current: 20, new: 32)
      padding: const EdgeInsets.all(32),

      // Option 2: You can also add vertical padding specifically
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),

      // Option 3: Set a minimum height constraint
      constraints: const BoxConstraints(
        minHeight: 120, // Adjust this value as needed
      ),

      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (showBackButton) ...[
              IconButton(
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: showBackButton ? TextAlign.left : TextAlign.center,
              ),
            ),
            if (showBackButton)
              const SizedBox(width: 32), // Balance the back button
          ],
        ),
      ),
    );
  }
}
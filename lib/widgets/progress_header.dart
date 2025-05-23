import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const ProgressHeader({
    Key? key,
    required this.title,
    this.onBackPressed,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Black header background with rounded bottom corners
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Container(  // Removed SafeArea
              height: 120,  // Reduced height
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          // Progress bar positioned absolutely
          Positioned(
            left: 20,
            right: 20,
            bottom: -45,
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // First dot with special handling
                  _buildStep(0),

                  // Middle dots with connecting lines
                  for (int i = 1; i < totalSteps; i++) ...[
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i < currentStep - 1 ? Colors.green : Colors.grey.shade300,
                      ),
                    ),
                    _buildStep(i),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int index) {
    final isCompleted = index < currentStep - 1; // Only steps BEFORE current are completed
    final isCurrent = index == currentStep - 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dot with potential checkmark
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : (isCurrent ? Colors.black : Colors.grey.shade400),
          ),
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 12)
              : null,
        ),
        const SizedBox(height: 8),
        // Step label
        Text(
          stepLabels[index],
          style: TextStyle(
            fontSize: 12,
            color: isCompleted || isCurrent ? Colors.black : Colors.grey.shade500,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../widgets/custom_header.dart'; // Assuming you have this widget
import '../widgets/next_button.dart'; // Assuming you have this widget

class BranchScreen extends StatefulWidget {
  const BranchScreen({Key? key}) : super(key: key);

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

// Add SingleTickerProviderStateMixin for animation controller
class _BranchScreenState extends State<BranchScreen> with SingleTickerProviderStateMixin {
  String? selectedBranchId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Make sure these image paths are correct in your assets folder
  final List<Map<String, dynamic>> _branches = [
    {
      'id': '1',
      'name': 'grow Tokyo BKK',
      'image': 'assets/images/branch1.jpg',
      'isSelected': true,
    },
    {
      'id': '2',
      'name': 'grow Tokyo TK',
      'image': 'assets/images/branch2.jpg',
      'isSelected': false,
    },
    {
      'id': '3',
      'name': 'Toms grow Tokyo',
      'image': 'assets/images/branch3.jpg',
      'isSelected': false,
    },
    {
      'id': '4',
      'name': 'Cozy grow Tokyo',
      'image': 'assets/images/branch3.jpg',
      'isSelected': false,
    },
    {
      'id': '5',
      'name': 'Nico grow Tokyo',
      'image': 'assets/images/branch3.jpg',
      'isSelected': false,
    },
  ];

  void _selectBranch(String branchId) {
    setState(() {
      selectedBranchId = branchId;
      for (var branch in _branches) {
        branch['isSelected'] = branch['id'] == branchId;
      }
    });
  }

  void _onNextPressed() {
    if (selectedBranchId != null) {
      Navigator.of(context).pushNamed('/staff', arguments: selectedBranchId);
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize selectedBranchId with the first selected branch
    selectedBranchId = _branches.firstWhere((branch) => branch['isSelected'] == true, orElse: () => _branches.first)['id'];
    // Ensure only one branch is initially selected if multiple were marked true
    if (selectedBranchId != null) {
      _selectBranch(selectedBranchId!);
    }

    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Total duration for all items
    );

    // Start the animation when the screen loads
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Or your desired background color
      body: Column(
        children: [
          const CustomHeader(
            title: 'Choose Branch',
          ),
          Expanded(
            child: Padding(
              // Padding around the list items
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                // Remove default ListView padding to eliminate the gap
                padding: const EdgeInsets.only(top: 16),
                itemCount: _branches.length,
                itemBuilder: (context, index) {
                  final branch = _branches[index];
                  final isSelected = branch['isSelected'] == true;

                  // Calculate staggered animation interval for each item
                  final double itemStartTime = (index * 0.1).clamp(0.0, 1.0);
                  final double itemEndTime = (itemStartTime + 0.4).clamp(0.0, 1.0);

                  // Create curved animations for fade and slide
                  final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(itemStartTime, itemEndTime, curve: Curves.easeOut),
                    ),
                  );
                  final slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(itemStartTime, itemEndTime, curve: Curves.easeOut),
                    ),
                  );

                  // Wrap the item with FadeTransition and SlideTransition
                  return FadeTransition(
                    opacity: fadeAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: Container(
                        // Margin between list items
                        margin: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => _selectBranch(branch['id']),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect( // Clip the content to the rounded corners
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  // Background image
                                  Positioned.fill(
                                    child: Image.asset(
                                      branch['image'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        // Placeholder in case image fails to load
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(Icons.image_not_supported, color: Colors.grey),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Overlay gradient
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.1),
                                          Colors.black.withOpacity(0.7),
                                        ],
                                        stops: const [0.3, 1.0], // Adjust gradient spread
                                      ),
                                    ),
                                  ),

                                  // Selection overlay
                                  if (isSelected)
                                    Container(
                                      color: Colors.black.withOpacity(0.5),
                                    ),

                                  // Content
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    right: 20,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          branch['name'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            shadows: [ // Add shadow for better readability
                                              Shadow(blurRadius: 2.0, color: Colors.black54, offset: Offset(1, 1)),
                                            ],
                                          ),
                                        ),
                                        if (branch['subtitle'] != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            branch['subtitle'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              shadows: [
                                                Shadow(blurRadius: 2.0, color: Colors.black54, offset: Offset(1, 1)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  // Selection indicator (centered checkmark)
                                  if (isSelected)
                                    Positioned(
                                      top: 60,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 60,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Next button
          NextButton(
            onPressed: selectedBranchId != null ? _onNextPressed : null,
            isEnabled: selectedBranchId != null,
          ),
        ],
      ),
    );
  }
}

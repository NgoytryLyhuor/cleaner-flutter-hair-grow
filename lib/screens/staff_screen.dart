import 'package:flutter/material.dart';
import '../widgets/progress_header.dart';
import '../widgets/next_button.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({Key? key}) : super(key: key);

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> with TickerProviderStateMixin {
  String? _selectedStaffId;
  late AnimationController _animationController;
  late AnimationController _staggeredAnimationController; // New controller for staggered animation
  late Animation<double> _scaleAnimation;

  // Sample staff data with descriptions instead of services
  final List<Map<String, dynamic>> _staffList = [
    {
      'id': '1',
      'name': 'Chandeth',
      'title': 'Cambodian Hairstylist',
      'description': 'Ladys Cut \$18 • Mens Cut \$15 • Kids Cut \$11',
      'image': 'assets/users/chandeth.jpg',
    },
    {
      'id': '2',
      'name': 'Mochi',
      'title': 'Cambodian Hairstylist',
      'description': 'Lady\'s Cut \$18 • Men\'s Cut \$15 • Kids Cut \$11',
      'image': 'assets/users/mochi.jpg',
    },
    {
      'id': '3',
      'name': 'Takuma',
      'title': 'Japanese Hairstylist',
      'description': 'Men\'s Hair Cut \$35 • Lady\'s Hair Cut \$40 • Kids Cut \$25',
      'image': 'assets/users/takuma.jpg',
    },
    {
      'id': '4',
      'name': 'Chiva',
      'title': 'Top stylist Price',
      'description': 'Lady\'s Cut \$21 • Men\'s Cut \$18 • Kids Cut \$14',
      'image': 'assets/users/chiva.jpg',
    },
    {
      'id': '5',
      'name': 'Hana',
      'title': 'Senior Stylist',
      'description': 'Lady\'s Cut \$22 • Men\'s Cut \$17 • Kids Cut \$13',
      'image': 'assets/users/hana.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Original animation controller for selection feedback
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // New staggered animation controller for screen entry
    _staggeredAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Total duration for all items
    );

    // Start the staggered animation when the screen loads
    _staggeredAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _staggeredAnimationController.dispose(); // Dispose the new controller
    super.dispose();
  }

  void _selectStaff(String staffId) {
    setState(() {
      _selectedStaffId = staffId;
    });

    // Trigger selection animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _onNextPressed() {
    if (_selectedStaffId != null) {
      Navigator.of(context).pushNamed('/service', arguments: _selectedStaffId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Scrollable Content Area (now full screen)
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Top padding to account for header height
                  const SizedBox(height: 140), // Adjust this value based on your header height

                  // Subtitle with fade animation
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _staggeredAnimationController,
                        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
                      ),
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
                        CurvedAnimation(
                          parent: _staggeredAnimationController,
                          curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          'Choose Your Stylist',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Staff List with staggered animation
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _staffList.length,
                    itemBuilder: (context, index) {
                      final staff = _staffList[index];
                      final bool isSelected = staff['id'] == _selectedStaffId;

                      // Calculate staggered animation interval for each item
                      final double itemStartTime = (0.2 + index * 0.1).clamp(0.0, 1.0);
                      final double itemEndTime = (itemStartTime + 0.4).clamp(0.0, 1.0);

                      // Create curved animations for fade and slide
                      final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _staggeredAnimationController,
                          curve: Interval(itemStartTime, itemEndTime, curve: Curves.easeOut),
                        ),
                      );
                      final slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
                        CurvedAnimation(
                          parent: _staggeredAnimationController,
                          curve: Interval(itemStartTime, itemEndTime, curve: Curves.easeOut),
                        ),
                      );

                      return FadeTransition(
                        opacity: fadeAnimation,
                        child: SlideTransition(
                          position: slideAnimation,
                          child: AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: isSelected ? _scaleAnimation.value : 1.0,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: GestureDetector(
                                    onTap: () => _selectStaff(staff['id']),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 150),
                                      curve: Curves.easeInOut,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected ? Colors.black : Colors.transparent,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isSelected
                                                ? Colors.black.withOpacity(0.15)
                                                : Colors.black.withOpacity(0.05),
                                            blurRadius: isSelected ? 12 : 8,
                                            offset: const Offset(0, 2),
                                            spreadRadius: isSelected ? 1 : 0,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          // Staff Image
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 150),
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: isSelected
                                                  ? Border.all(color: Colors.black, width: 2)
                                                  : null,
                                              image: DecorationImage(
                                                image: AssetImage(staff['image']),
                                                fit: BoxFit.cover,
                                                onError: (exception, stackTrace) {
                                                  // Handle image loading error
                                                },
                                              ),
                                            ),
                                            child: staff['image'].isEmpty
                                                ? Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                            )
                                                : null,
                                          ),

                                          const SizedBox(width: 16),

                                          // Staff Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Name
                                                AnimatedDefaultTextStyle(
                                                  duration: const Duration(milliseconds: 150),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: isSelected ? Colors.black : Colors.black87,
                                                  ),
                                                  child: Text(staff['name']),
                                                ),

                                                const SizedBox(height: 4),

                                                // Title
                                                AnimatedDefaultTextStyle(
                                                  duration: const Duration(milliseconds: 150),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: isSelected
                                                        ? Colors.grey[700]
                                                        : Colors.grey[600],
                                                  ),
                                                  child: Text(staff['title']),
                                                ),

                                                const SizedBox(height: 8),

                                                // Description
                                                AnimatedDefaultTextStyle(
                                                  duration: const Duration(milliseconds: 150),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: isSelected
                                                        ? Colors.grey[700]
                                                        : Colors.grey[600],
                                                  ),
                                                  child: Text(staff['description']),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  // Bottom padding for scroll area
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Progress Header (now overlays the content with transparent background)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProgressHeader(
              title: 'grow Tokyo BKK',
              currentStep: 1,
              totalSteps: 3,
              stepLabels: ['Staff', 'Services', 'Date & Time'],
              onBackPressed: () => Navigator.of(context).pop(),
              // You'll need to add this parameter to make background transparent
              // backgroundColor: Colors.transparent, // Add this to ProgressHeader widget
            ),
          ),

          // Next Button (positioned at bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.grey[100], // Match scaffold background
              child: NextButton(
                onPressed: _selectedStaffId != null ? _onNextPressed : null,
                isEnabled: _selectedStaffId != null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
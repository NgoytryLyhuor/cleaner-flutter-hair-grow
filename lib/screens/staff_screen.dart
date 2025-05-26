import 'package:flutter/material.dart';
import '../widgets/progress_header.dart';
import '../widgets/next_button.dart';
import '../services/api_service.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({Key? key}) : super(key: key);

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> with TickerProviderStateMixin {
  String? _selectedStaffId;
  String? _branchId;
  late AnimationController _animationController;
  late AnimationController _staggeredAnimationController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Future<List<Map<String, dynamic>>> _staffFuture;
  List<Map<String, dynamic>> _staffList = [];
  bool _hasAnimated = false;
  final ApiService _apiService = ApiService();

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
      duration: const Duration(milliseconds: 800),
    );

    // Initialize shimmer controller for skeleton loading
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get branch_id from navigation arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      _branchId = args;
      _loadStaff();
    }
  }

  void _loadStaff() {
    if (_branchId != null) {
      _staffFuture = _apiService.getStaffList(_branchId!);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _staggeredAnimationController.dispose();
    _shimmerController.dispose();
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

  void _onDataLoaded(List<Map<String, dynamic>> staffList) {
    setState(() {
      _staffList = staffList;
    });

    // Start animation after data is loaded
    if (!_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _staggeredAnimationController.forward();
        }
      });
    }
  }

  void _onRetry() {
    setState(() {
      _staggeredAnimationController.reset();
      _hasAnimated = false;
      _loadStaff();
    });
  }

  void _showCenteredAlert(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onNextPressed() {
    if (_selectedStaffId != null) {
      Navigator.of(context).pushNamed('/service', arguments: _selectedStaffId);
    } else {
      _showCenteredAlert('Please select a stylist to continue');
    }
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 5, // Show 5 skeleton items
      itemBuilder: (context, index) {
        return _buildSkeletonItem();
      },
    );
  }

  Widget _buildSkeletonItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile image skeleton
          _buildShimmerBox(width: 70, height: 70, borderRadius: 35),
          const SizedBox(width: 16),
          // Text content skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerBox(width: 120, height: 16, borderRadius: 4),
                const SizedBox(height: 8),
                _buildShimmerBox(width: 200, height: 12, borderRadius: 4),
              ],
            ),
          ),
          // Radio button skeleton
          _buildShimmerBox(width: 20, height: 20, borderRadius: 10),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double borderRadius = 4,
  }) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _shimmerController.value * 2, 0.0),
              end: Alignment(1.0 + _shimmerController.value * 2, 0.0),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStaffList(List<Map<String, dynamic>> staffList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        final staff = staffList[index];
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Staff Image
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                color: Colors.grey[300],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: staff['image'].isNotEmpty
                                    ? Image.network(
                                  staff['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                    );
                                  },
                                )
                                    : const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Staff Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name
                                  Text(
                                    staff['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Description
                                  Text(
                                    staff['description'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Radio Button
                            Radio<String>(
                              value: staff['id'],
                              groupValue: _selectedStaffId,
                              onChanged: (String? value) {
                                if (value != null) {
                                  _selectStaff(value);
                                }
                              },
                              activeColor: Colors.black,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Scrollable Content Area
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Top padding to account for header height
                  const SizedBox(height: 140),

                  // Subtitle
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Choose Your Stylist',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Staff List with API data
                  if (_branchId != null)
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _staffFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildSkeletonList();
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, size: 48, color: Colors.grey[600]),
                                const SizedBox(height: 16),
                                Text('Error loading staff', style: TextStyle(color: Colors.grey[600])),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _onRetry,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          // Update local state when data is loaded
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (_staffList.isEmpty || _staffList != snapshot.data!) {
                              _onDataLoaded(snapshot.data!);
                            }
                          });

                          return _buildStaffList(snapshot.data!);
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people_outline, size: 48, color: Colors.grey[600]),
                                const SizedBox(height: 16),
                                Text('No staff available', style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          );
                        }
                      },
                    )
                  else
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.grey[600]),
                          const SizedBox(height: 16),
                          Text('Branch not selected', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),

                  // Bottom padding for scroll area
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Progress Header
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
            ),
          ),

          // Next Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.grey[100],
              child: NextButton(
                onPressed: _onNextPressed,
                isEnabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
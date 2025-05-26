// lib/screens/branch_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/next_button.dart';
import '../services/api_service.dart';

class BranchScreen extends StatefulWidget {
  const BranchScreen({Key? key}) : super(key: key);

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> with TickerProviderStateMixin {
  String? selectedBranchId;
  late AnimationController _animationController;
  late AnimationController _shimmerController;
  List<Map<String, dynamic>> _branches = [];
  late Future<List<Map<String, dynamic>>> _branchFuture;
  final ApiService _apiService = ApiService();
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController for branch cards
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Initialize shimmer controller for skeleton loading
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    // Load branch data from API
    _loadBranches();
  }

  void _loadBranches() {
    _branchFuture = _apiService.getBranchList();
  }

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

  void _onDataLoaded(List<Map<String, dynamic>> branches) {
    setState(() {
      _branches = branches;

      // Set first branch as selected by default
      if (branches.isNotEmpty) {
        selectedBranchId = branches.first['id'];
        _selectBranch(selectedBranchId!);
      }
    });

    // Start animation after data is loaded
    if (!_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _animationController.forward();
        }
      });
    }
  }

  void _onRetry() {
    setState(() {
      _animationController.reset();
      _loadBranches();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Widget _buildSkeletonList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: 4, // Show 4 skeleton cards
        itemBuilder: (context, index) {
          return _buildSkeletonCard();
        },
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background skeleton
            Positioned.fill(
              child: _buildShimmerBox(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 12,
              ),
            ),

            // Bottom content skeleton
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerBox(width: 150, height: 18, borderRadius: 4),
                  const SizedBox(height: 8),
                  _buildShimmerBox(width: 100, height: 14, borderRadius: 4),
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildBranchList(List<Map<String, dynamic>> branches) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: branches.length,
        itemBuilder: (context, index) {
          final branch = branches[index];
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

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: Container(
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          // Background image (network image from API)
                          Positioned.fill(
                            child: branch['image'].isNotEmpty
                                ? Image.network(
                              branch['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                                  ),
                                );
                              },
                            )
                                : Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image_not_supported, color: Colors.grey),
                              ),
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
                                stops: const [0.3, 1.0],
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
                                    shadows: [
                                      Shadow(blurRadius: 2.0, color: Colors.black54, offset: Offset(1, 1)),
                                    ],
                                  ),
                                ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const CustomHeader(
            title: 'Choose Branch',
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _branchFuture,
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
                        Text('Error loading branches', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _onRetry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  // Update local state when data is loaded
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_branches.isEmpty) {
                      _onDataLoaded(snapshot.data!);
                    }
                  });

                  return _buildBranchList(snapshot.data!);
                } else {
                  return _buildSkeletonList();
                }
              },
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
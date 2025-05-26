import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasAnimated = false;
  late AnimationController _animationController;
  late AnimationController _shimmerController;
  late AnimationController _staggeredController;
  final List<AnimationController> _cardAnimationControllers = [];
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  // Sample coupon data
  final List<Map<String, dynamic>> _coupons = [
    {
      'id': '1',
      'title': 'Coupon test by developer',
      'validUntil': '26/05/2025',
      'discountCode': 'JSHFHV12HD',
      'description': 'Get special discount on your booking with this exclusive coupon.',
    },
    {
      'id': '2',
      'title': 'Welcome Bonus',
      'validUntil': '30/06/2025',
      'discountCode': 'WELCOME25',
      'description': 'Welcome to our salon! Get exclusive discount on your first visit.',
    },
  ];

  @override
  void initState() {
    super.initState();
    print('CouponScreen: initState called, _isLoading = $_isLoading');

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    // Controller for staggered animations
    _staggeredController = AnimationController(
      duration: Duration(milliseconds: 200 + (_coupons.length * 100)),
      vsync: this,
    );

    // Initialize individual card animations
    _initializeCardAnimations();

    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 500), () {
      print('CouponScreen: Loading timer completed');
      if (mounted) {
        print('CouponScreen: Widget is mounted, setting _isLoading to false');
        setState(() {
          _isLoading = false;
        });

        // Start the staggered animation after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && !_hasAnimated) {
            _hasAnimated = true;
            _startCardAnimations();
          }
        });
      } else {
        print('CouponScreen: Widget is not mounted');
      }
    });
  }

  void _initializeCardAnimations() {
    for (int i = 0; i < _coupons.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );

      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));

      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));

      _cardAnimationControllers.add(controller);
      _slideAnimations.add(slideAnimation);
      _fadeAnimations.add(fadeAnimation);
    }
  }

  void _startCardAnimations() async {
    for (int i = 0; i < _cardAnimationControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 100));
      if (mounted) {
        _cardAnimationControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    _staggeredController.dispose();
    for (final controller in _cardAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildSkeletonCard();
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              // Left side - Coupon icon skeleton (50x50 to match actual icon container)
              _buildShimmerBox(width: 50, height: 50, borderRadius: 8),
              const SizedBox(width: 16),

              // Right side - Content skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title skeleton
                    _buildShimmerBox(width: double.infinity, height: 16),
                    const SizedBox(height: 4),

                    // Valid until skeleton
                    _buildShimmerBox(width: 120, height: 12),
                    const SizedBox(height: 4),

                    // Details skeleton
                    _buildShimmerBox(width: 60, height: 14),
                  ],
                ),
              ),
            ],
          ),
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

  void _showCouponDetails(Map<String, dynamic> coupon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCouponDetailsModal(coupon),
    );
  }

  Widget _buildCouponDetailsModal(Map<String, dynamic> coupon) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header with close button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  coupon['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discount Code: ${coupon['discountCode']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Valid until: ${coupon['validUntil']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Coupon Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    coupon['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(Map<String, dynamic> coupon, int index) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  // Left side - Coupon icon with light red background
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/coupon_discount.png',
                        width: 24,
                        height: 24,
                        color: Colors.red,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.local_offer,
                            color: Colors.red,
                            size: 24,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Right side - Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main title
                        Text(
                          coupon['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Valid until date
                        Text(
                          'Valid until ${coupon['validUntil']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Details with underline
                        GestureDetector(
                          onTap: () => _showCouponDetails(coupon),
                          child: const Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('CouponScreen: build called, _isLoading = $_isLoading');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Custom header with back button
          const CustomHeader(
            title: 'Coupon',
          ),

          // Coupons list
          Expanded(
            child: _isLoading
                ? _buildSkeletonList()
                : _coupons.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _coupons.length,
              itemBuilder: (context, index) {
                final coupon = _coupons[index];
                return _buildCouponCard(coupon, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/coupon_discount.png',
                width: 40,
                height: 40,
                color: Colors.red,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.local_offer_outlined,
                    color: Colors.red,
                    size: 40,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Coupons Available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for exclusive offers',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
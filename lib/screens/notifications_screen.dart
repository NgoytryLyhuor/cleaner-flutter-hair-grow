import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasAnimated = false;
  late AnimationController _shimmerController;
  late AnimationController _staggeredController;

  // List to track individual card animations
  List<Animation<double>> _cardFadeAnimations = [];
  List<Animation<Offset>> _cardSlideAnimations = [];

  // Sample notifications data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '#5198',
      'title': 'Booking Confirmation Received!',
      'date': '24-May-2025 05:32 PM',
    },
    {
      'id': '#5181',
      'title': 'Booking Cancellation',
      'date': '24-May-2025 04:18 PM',
    },
    {
      'id': '#3454',
      'title': 'Booking Confirmation Received!',
      'date': '12-Apr-2025 11:02 AM',
    },
    {
      'id': '#3450',
      'title': 'Booking Cancellation',
      'date': '12-Apr-2025 10:38 AM',
    },
    {
      'id': '#3450',
      'title': 'Booking Confirmation Received!',
      'date': '12-Apr-2025 10:35 AM',
    },
    {
      'id': '#3425',
      'title': 'Booking Cancellation',
      'date': '11-Apr-2025 05:00 PM',
    },
    {
      'id': '#3425',
      'title': 'Booking Confirmation Received!',
      'date': '11-Apr-2025 05:00 PM',
    },
    {
      'id': '#3422',
      'title': 'Booking Cancellation',
      'date': '11-Apr-2025 04:58 PM',
    },
    {
      'id': '#3422',
      'title': 'Booking Confirmation Received!',
      'date': '11-Apr-2025 04:57 PM',
    },
    {
      'id': '#3421',
      'title': 'Booking Cancellation',
      'date': '11-Apr-2025 04:55 PM',
    },
    {
      'id': '#3421',
      'title': 'Booking Confirmation Received!',
      'date': '11-Apr-2025 04:53 PM',
    },
  ];

  @override
  void initState() {
    super.initState();
    print('NotificationsScreen: initState called, _isLoading = $_isLoading');

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    // Controller for staggered animations - same as MyBookingScreen
    _staggeredController = AnimationController(
      duration: Duration(milliseconds: 200 + (_notifications.length * 100)), // Same duration calculation as MyBookingScreen
      vsync: this,
    );

    _initializeCardAnimations();

    // Simulate loading data - same duration as MyBookingScreen
    Future.delayed(const Duration(milliseconds: 500), () {
      print('NotificationsScreen: Loading timer completed');
      if (mounted) {
        print('NotificationsScreen: Widget is mounted, setting _isLoading to false');
        setState(() {
          _isLoading = false;
        });

        // Start the staggered animation after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && !_hasAnimated) {
            _hasAnimated = true;
            _staggeredController.forward();
          }
        });
      } else {
        print('NotificationsScreen: Widget is not mounted');
      }
    });
  }

  void _initializeCardAnimations() {
    _cardFadeAnimations.clear();
    _cardSlideAnimations.clear();

    for (int i = 0; i < _notifications.length; i++) {
      // Calculate staggered intervals - same as MyBookingScreen
      double startTime = (i * 0.1).clamp(0.0, 0.8); // Start time for each card
      double endTime = (startTime + 0.4).clamp(0.0, 1.0); // End time for each card

      // Fade animation for each card
      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _staggeredController,
        curve: Interval(startTime, endTime, curve: Curves.easeOut),
      ));

      // Slide animation for each card - same as MyBookingScreen
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.0, 0.5), // Start from below - same as MyBookingScreen
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _staggeredController,
        curve: Interval(startTime, endTime, curve: Curves.easeOutCubic),
      ));

      _cardFadeAnimations.add(fadeAnimation);
      _cardSlideAnimations.add(slideAnimation);
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _staggeredController.dispose();
    super.dispose();
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16), // Same padding as MyBookingScreen
      itemCount: 5, // Same count as MyBookingScreen
      itemBuilder: (context, index) {
        return _buildSkeletonCard();
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), // Match notification card margin
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10), // Match notification card padding
        child: Row(
          children: [
            // Left side - Notification icon skeleton (40x40 to match actual icon)
            _buildShimmerBox(width: 40, height: 40, borderRadius: 20),
            const SizedBox(width: 16), // Match spacing

            // Right side - Content skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row - ID and Date skeleton
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildShimmerBox(width: 60, height: 14), // Match ID font size
                      _buildShimmerBox(width: 120, height: 12), // Match date font size
                    ],
                  ),
                  const SizedBox(height: 5), // Match spacing

                  // Title skeleton
                  _buildShimmerBox(width: double.infinity, height: 12), // Match title font size
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

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return SlideTransition(
      position: _cardSlideAnimations[index],
      child: FadeTransition(
        opacity: _cardFadeAnimations[index],
        child: Container(
          margin: const EdgeInsets.only(bottom: 10), // Same margin as MyBookingScreen
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // Add tap animation and navigation if needed
              print('Notification tapped: ${notification['id']}');
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10), // Same padding as MyBookingScreen
              child: Row(
                children: [
                  // Left side - Notification icon
                  Container(
                    child: Center(
                      child: Image.asset(
                        'assets/icons/ic_notification_user.png',
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              Icons.notifications,
                              color: Colors.blue[600],
                              size: 24,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 16), // Increased spacing

                  // Right side - Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row - Notification ID and Date with space between
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Notification ID
                            Text(
                              notification['id'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            // Date and time
                            Text(
                              notification['date'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5), // Increased spacing

                        // Main title
                        Text(
                          notification['title'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
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

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12), // Same padding as MyBookingScreen
      itemCount: _notifications.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationCard(notification, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('NotificationsScreen: build called, _isLoading = $_isLoading');

    return Scaffold(
      backgroundColor: Colors.grey[50], // Same background as MyBookingScreen
      body: Column(
        children: [
          // Custom header with back button
          const CustomHeader(
            title: 'Notifications',
          ),

          // Notifications list
          Expanded(
            child: _isLoading
                ? _buildSkeletonList()
                : _notifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: FadeTransition(
        opacity: _staggeredController.status == AnimationStatus.completed
            ? const AlwaysStoppedAnimation(1.0)
            : const AlwaysStoppedAnimation(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              child: Center(
                child: Image.asset(
                  'assets/icons/ic_notification_user.png',
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.grey[400],
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Notifications',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You don\'t have any notifications yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
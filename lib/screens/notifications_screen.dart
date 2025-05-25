import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final List<AnimationController> _cardAnimationControllers = [];
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize individual card animations
    _initializeCardAnimations();

    // Start animations after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCardAnimations();
    });
  }

  void _initializeCardAnimations() {
    for (int i = 0; i < _notifications.length; i++) {
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
      await Future.delayed(Duration(milliseconds: i * 50));
      if (mounted) {
        _cardAnimationControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final controller in _cardAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0.5,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // Left side - Notification icon
                  Container(
                    child: Center(
                      child: Image.asset(
                        'assets/icons/ic_notification_user.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

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
                                fontSize: 16,
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

                        const SizedBox(height: 8),

                        // Main title
                        Text(
                          notification['title'],
                          style: TextStyle(
                            fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Custom header with back button
          const CustomHeader(
            title: 'Notifications',
          ),

          // Notifications list
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(notification, index);
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
            child: Center(
              child: Image.asset(
                'assets/icons/ic_notification_user.png',
                width: 40,
                height: 40,
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
    );
  }
}
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/booking_header.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen>
    with TickerProviderStateMixin {
  final String _currentPage = 'My Booking';
  bool _isLoading = true;
  bool _hasAnimated = false;
  late AnimationController _shimmerController;
  late AnimationController _staggeredController;

  // List to track individual card animations
  List<Animation<double>> _cardFadeAnimations = [];
  List<Animation<Offset>> _cardSlideAnimations = [];

  // Sample booking data - 12 items
  final List<Map<String, dynamic>> _bookingData = [
    {
      'id': '3454',
      'service': 'grow Tokyo Ho Chi Minh City (HCMC)',
      'serviceDescription': 'Cut (For Lady), Cut (For Men)',
      'serviceImage': 'assets/services/cut-man.jpg',
      'date': '20/04/2025',
      'time': '10:00',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Confirmed',
    },
    {
      'id': '3450',
      'service': 'Cozy grow Tokyo',
      'serviceDescription': 'Cut (For Men), Cut (For Lady)',
      'serviceImage': 'assets/services/cut-man.jpg',
      'date': '20/04/2025',
      'time': '10:00',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Cancelled',
    },
    {
      'id': '3455',
      'service': 'Tokyo Beauty Spa',
      'serviceDescription': 'Facial Treatment, Hair Wash',
      'serviceImage': 'assets/services/cut-man.jpg',
      'date': '21/04/2025',
      'time': '11:30',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Pending',
    },
    {
      'id': '3456',
      'service': 'Shinjuku Nails',
      'serviceDescription': 'Manicure, Pedicure',
      'serviceImage': 'assets/services/nails.jpg',
      'date': '22/04/2025',
      'time': '14:00',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Confirmed',
    },
    {
      'id': '3457',
      'service': 'Tokyo Relax Massage',
      'serviceDescription': 'Full Body Massage',
      'serviceImage': 'assets/services/cut-man.jpg',
      'date': '23/04/2025',
      'time': '15:00',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Pending',
    },
    {
      'id': '3458',
      'service': 'Hair Tokyo Lounge',
      'serviceDescription': 'Hair Coloring, Blow Dry',
      'serviceImage': 'assets/services/cut-man.jpg',
      'date': '24/04/2025',
      'time': '13:00',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Confirmed',
    },
    {
      'id': '3459',
      'service': 'Tokyo Spa & Relax',
      'serviceDescription': 'Foot Massage, Oil Treatment',
      'serviceImage': 'assets/services/cut-man.jpg',
      'date': '25/04/2025',
      'time': '12:30',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Pending',
    },
    {
      'id': '3460',
      'service': 'Luxury Nail Bar Tokyo',
      'serviceDescription': 'Gel Nails, Nail Art',
      'serviceImage': 'assets/services/cut-man.jpg',
      'date': '26/04/2025',
      'time': '16:00',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Confirmed',
    },
    {
      'id': '3461',
      'service': 'Tokyo Hair Designers',
      'serviceDescription': 'Hair Cut (Men), Styling',
      'serviceImage': 'assets/services/cut-man.jpg',
      'date': '27/04/2025',
      'time': '09:30',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Pending',
    },
    {
      'id': '3462',
      'service': 'Shibuya Spa Lounge',
      'serviceDescription': 'Hot Stone Massage, Facial',
      'serviceImage': 'assets/services/cut-man.jpg',
      'date': '28/04/2025',
      'time': '17:00',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Confirmed',
    },
    {
      'id': '3463',
      'service': 'Ginza Beauty Salon',
      'serviceDescription': 'Scalp Treatment, Blow Dry',
      'serviceImage': 'assets/services/cut-man.jpg',
      'date': '29/04/2025',
      'time': '10:30',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Pending',
    },
    {
      'id': '3464',
      'service': 'Tokyo Men\'s Spa',
      'serviceDescription': 'Facial, Beard Trim',
      'serviceImage': 'assets/services/cut-man.jpg',
      'date': '30/04/2025',
      'time': '18:00',
      'staff': 'Mochi',
      'staffImage': 'assets/users/mochi.jpg',
      'status': 'Confirmed',
    },
  ];

  @override
  void initState() {
    super.initState();
    print('MyBookingScreen: initState called, _isLoading = $_isLoading');

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    // Controller for staggered animations
    _staggeredController = AnimationController(
      duration: Duration(milliseconds: 200 + (_bookingData.length * 100)), // Dynamic duration based on item count
      vsync: this,
    );

    _initializeCardAnimations();

    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 800), () {
      print('MyBookingScreen: Loading timer completed');
      if (mounted) {
        print('MyBookingScreen: Widget is mounted, setting _isLoading to false');
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
        print('MyBookingScreen: Widget is not mounted');
      }
    });
  }

  void _initializeCardAnimations() {
    _cardFadeAnimations.clear();
    _cardSlideAnimations.clear();

    for (int i = 0; i < _bookingData.length; i++) {
      // Calculate staggered intervals
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

      // Slide animation for each card
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.0, 0.5), // Start from below
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

  void _navigateToPage(String pageName) {
    switch (pageName) {
      case 'Home':
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 'My Booking':
      // Already on my booking
        break;
      case 'Shop':
        Navigator.of(context).pushReplacementNamed('/shop');
        break;
      case 'User':
        Navigator.of(context).pushReplacementNamed('/user');
        break;
    }
  }

  void _viewBookingDetails(String bookingId) {
    Navigator.of(context).pushNamed('/my-booking-details', arguments: bookingId);
  }

  @override
  Widget build(BuildContext context) {
    print('MyBookingScreen: build called, _isLoading = $_isLoading');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header Widget - No SafeArea wrapper here
          const BookingHeader(title: 'My Booking'),

          // Content with SafeArea only for bottom
          Expanded(
            child: SafeArea(
              top: false, // Don't add safe area padding to top
              child: _isLoading
                  ? _buildSkeletonList()
                  : _bookingData.isEmpty
                  ? _buildEmptyState()
                  : _buildBookingsList(),
            ),
          ),

          // Bottom Navigation with SafeArea for consistent positioning
          SafeArea(
            top: false, // Only apply safe area to bottom
            child: BottomNavigation(
              currentPage: _currentPage,
              onPageChanged: _navigateToPage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Show 5 skeleton items
      itemBuilder: (context, index) {
        return _buildSkeletonCard();
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking ID skeleton
            _buildShimmerBox(width: 60, height: 16),
            const SizedBox(height: 12),

            // Service Info Row skeleton
            Row(
              children: [
                // Service Image skeleton
                _buildShimmerBox(width: 60, height: 60, borderRadius: 8),
                const SizedBox(width: 12),

                // Service Details skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerBox(width: double.infinity, height: 18),
                      const SizedBox(height: 4),
                      _buildShimmerBox(width: 120, height: 14),
                    ],
                  ),
                ),

                // Status Badge skeleton
                _buildShimmerBox(width: 80, height: 28, borderRadius: 16),
              ],
            ),

            const SizedBox(height: 16),

            // Staff Info Row skeleton
            Row(
              children: [
                // Staff Image skeleton
                _buildShimmerBox(width: 24, height: 24, borderRadius: 12),
                const SizedBox(width: 8),
                _buildShimmerBox(width: 60, height: 16),
              ],
            ),

            const SizedBox(height: 12),

            // Date and Time Row skeleton
            Row(
              children: [
                _buildShimmerBox(width: 16, height: 16),
                const SizedBox(width: 8),
                _buildShimmerBox(width: 80, height: 16),
                const Spacer(),
                _buildShimmerBox(width: 16, height: 16),
                const SizedBox(width: 4),
                _buildShimmerBox(width: 50, height: 16),
              ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No bookings found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _bookingData.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final booking = _bookingData[index];

        // Wrap each card with its individual animations
        return SlideTransition(
          position: _cardSlideAnimations[index],
          child: FadeTransition(
            opacity: _cardFadeAnimations[index],
            child: _buildBookingCard(booking),
          ),
        );
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _viewBookingDetails(booking['id']),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking ID
              Text(
                '#${booking['id']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),

              // Service Info Row
              Row(
                children: [
                  // Service Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      booking['serviceImage'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.image,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Service Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['service'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking['serviceDescription'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  _buildStatusBadge(booking['status']),
                ],
              ),

              const SizedBox(height: 16),

              // Staff Info Row
              Row(
                children: [
                  // Staff Image
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage(booking['staffImage']),
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: booking['staffImage'].isEmpty
                        ? const Icon(Icons.person, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    booking['staff'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Date and Time Row
              Row(
                children: [
                  Image.asset(
                    'assets/icons/calendar.png',
                    width: 16,
                    height: 16,
                    color: _getStatusColor(booking['status']),
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: _getStatusColor(booking['status']),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    booking['date'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    booking['time'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.yellow[700]!;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
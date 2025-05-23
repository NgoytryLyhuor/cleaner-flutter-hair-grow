import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/loading.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> with SingleTickerProviderStateMixin {
  final String _currentPage = 'My Booking';
  late TabController _tabController;
  bool _isLoading = true;
  
  // Sample booking data
  final List<Map<String, dynamic>> _upcomingBookings = [
    {
      'id': '1',
      'service': 'Haircut & Styling',
      'date': '2025-05-25',
      'time': '10:00 AM',
      'branch': 'Main Branch',
      'staff': 'John Doe',
      'status': 'Confirmed',
    },
    {
      'id': '2',
      'service': 'Hair Coloring',
      'date': '2025-06-02',
      'time': '2:30 PM',
      'branch': 'Downtown Branch',
      'staff': 'Jane Smith',
      'status': 'Pending',
    },
  ];
  
  final List<Map<String, dynamic>> _historyBookings = [
    {
      'id': '3',
      'service': 'Hair Treatment',
      'date': '2025-05-10',
      'time': '11:00 AM',
      'branch': 'Main Branch',
      'staff': 'John Doe',
      'status': 'Completed',
    },
    {
      'id': '4',
      'service': 'Haircut',
      'date': '2025-04-20',
      'time': '3:00 PM',
      'branch': 'Downtown Branch',
      'staff': 'Jane Smith',
      'status': 'Completed',
    },
    {
      'id': '5',
      'service': 'Styling',
      'date': '2025-04-05',
      'time': '1:30 PM',
      'branch': 'Main Branch',
      'staff': 'John Doe',
      'status': 'Cancelled',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: Loading())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Upcoming tab
                        _upcomingBookings.isEmpty
                            ? _buildEmptyState('No upcoming bookings')
                            : _buildBookingsList(_upcomingBookings),
                        
                        // History tab
                        _historyBookings.isEmpty
                            ? _buildEmptyState('No booking history')
                            : _buildBookingsList(_historyBookings),
                      ],
                    ),
            ),
            
            // Bottom Navigation
            BottomNavigation(
              currentPage: _currentPage,
              onPageChanged: _navigateToPage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
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
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Map<String, dynamic>> bookings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _viewBookingDetails(booking['id']),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        booking['service'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildStatusChip(booking['status']),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '${booking['date']} | ${booking['time']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        booking['branch'],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        booking['staff'],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor = Colors.white;
    
    switch (status) {
      case 'Confirmed':
        chipColor = Colors.green;
        break;
      case 'Pending':
        chipColor = Colors.orange;
        break;
      case 'Completed':
        chipColor = Colors.blue;
        break;
      case 'Cancelled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

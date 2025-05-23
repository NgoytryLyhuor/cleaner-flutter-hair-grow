import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;
  
  // Sample notifications data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Booking Confirmed',
      'message': 'Your booking for Men\'s Haircut on May 25, 2025 at 10:00 AM has been confirmed.',
      'date': 'May 20, 2025',
      'time': '2:30 PM',
      'isRead': true,
      'type': 'booking',
    },
    {
      'id': '2',
      'title': 'Special Offer',
      'message': 'Get 20% off on all hair treatments this weekend!',
      'date': 'May 18, 2025',
      'time': '10:15 AM',
      'isRead': false,
      'type': 'promotion',
    },
    {
      'id': '3',
      'title': 'Booking Reminder',
      'message': 'Reminder: You have an appointment tomorrow at 3:00 PM for Hair Coloring.',
      'date': 'May 15, 2025',
      'time': '4:00 PM',
      'isRead': true,
      'type': 'reminder',
    },
    {
      'id': '4',
      'title': 'Points Earned',
      'message': 'You\'ve earned 50 points from your recent booking!',
      'date': 'May 12, 2025',
      'time': '11:45 AM',
      'isRead': true,
      'type': 'points',
    },
    {
      'id': '5',
      'title': 'New Service Available',
      'message': 'We\'ve added a new hair treatment service. Check it out!',
      'date': 'May 10, 2025',
      'time': '9:30 AM',
      'isRead': false,
      'type': 'service',
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
      ),
    );
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n['id'] == id);
      notification['isRead'] = true;
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification deleted'),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.calendar_today;
      case 'promotion':
        return Icons.local_offer;
      case 'reminder':
        return Icons.alarm;
      case 'points':
        return Icons.star;
      case 'service':
        return Icons.spa;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'booking':
        return Colors.blue;
      case 'promotion':
        return Colors.purple;
      case 'reminder':
        return Colors.orange;
      case 'points':
        return Colors.amber;
      case 'service':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int unreadCount = _notifications.where((n) => n['isRead'] == false).length;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark all as read'),
            ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _notifications.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      final bool isRead = notification['isRead'] as bool;
                      
                      return Dismissible(
                        key: Key(notification['id']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          _deleteNotification(notification['id']);
                        },
                        child: InkWell(
                          onTap: () {
                            if (!isRead) {
                              _markAsRead(notification['id']);
                            }
                            // Navigate to relevant screen based on notification type
                            // For now, just show a snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Viewing: ${notification['title']}'),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            color: isRead ? null : Colors.blue.shade50,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _getNotificationColor(notification['type']).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getNotificationIcon(notification['type']),
                                    color: _getNotificationColor(notification['type']),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              notification['title'],
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${notification['date']} ${notification['time']}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notification['message'],
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You don\'t have any notifications yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

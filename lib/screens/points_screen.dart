import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({Key? key}) : super(key: key);

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  // Sample points data
  final Map<String, dynamic> _pointsData = {
    'total_points': 250,
    'history': [
      {
        'id': '1',
        'date': 'May 20, 2025',
        'description': 'Booking Completed',
        'points': 50,
        'type': 'earned',
      },
      {
        'id': '2',
        'date': 'May 15, 2025',
        'description': 'Referral Bonus',
        'points': 100,
        'type': 'earned',
      },
      {
        'id': '3',
        'date': 'May 10, 2025',
        'description': 'Discount Redemption',
        'points': -200,
        'type': 'redeemed',
      },
      {
        'id': '4',
        'date': 'May 5, 2025',
        'description': 'Booking Completed',
        'points': 50,
        'type': 'earned',
      },
      {
        'id': '5',
        'date': 'Apr 25, 2025',
        'description': 'Welcome Bonus',
        'points': 250,
        'type': 'earned',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Points'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Points summary
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_pointsData['total_points']}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Points',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Show redeem points dialog
                          _showRedeemPointsDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                        ),
                        child: const Text('Redeem Points'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          // Navigate to referral screen
                          Navigator.of(context).pushNamed('/referral');
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.amber.shade700),
                        ),
                        child: Text(
                          'Earn More',
                          style: TextStyle(color: Colors.amber.shade700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Points history
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Points History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _pointsData['history'].length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = _pointsData['history'][index];
                        final bool isEarned = item['type'] == 'earned';
                        
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isEarned ? Colors.green.shade100 : Colors.red.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isEarned ? Icons.add : Icons.remove,
                              color: isEarned ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(item['description']),
                          subtitle: Text(item['date']),
                          trailing: Text(
                            isEarned ? '+${item['points']}' : '-${item['points']}',
                            style: TextStyle(
                              color: isEarned ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRedeemPointsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redeem Points'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('10% Discount'),
              subtitle: const Text('Valid for your next booking'),
              trailing: const Text('200 pts'),
              onTap: () {
                Navigator.of(context).pop();
                _confirmRedemption('10% Discount', 200);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Free Hair Treatment'),
              subtitle: const Text('With any haircut service'),
              trailing: const Text('500 pts'),
              onTap: () {
                Navigator.of(context).pop();
                _confirmRedemption('Free Hair Treatment', 500);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Free Haircut'),
              subtitle: const Text('Any style of your choice'),
              trailing: const Text('1000 pts'),
              onTap: () {
                Navigator.of(context).pop();
                _confirmRedemption('Free Haircut', 1000);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _confirmRedemption(String reward, int points) {
    if (_pointsData['total_points'] < points) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not enough points. You need $points points.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Redemption'),
        content: Text('Are you sure you want to redeem $reward for $points points?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              
              // Simulate successful redemption
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully redeemed $reward'),
                ),
              );
              
              // Update points in a real app
              setState(() {
                _pointsData['total_points'] -= points;
                _pointsData['history'].insert(0, {
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'date': 'May 22, 2025',
                  'description': 'Redeemed $reward',
                  'points': points,
                  'type': 'redeemed',
                });
              });
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

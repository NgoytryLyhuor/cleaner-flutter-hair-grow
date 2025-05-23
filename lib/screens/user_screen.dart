import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final String _currentPage = 'User';
  
  // Sample user data
  final Map<String, dynamic> _userData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+1 234 567 8901',
    'points': 250,
  };
  
  // Menu items
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Edit Profile',
      'icon': Icons.person_outline,
      'route': '/edit-profile',
    },
    {
      'title': 'My Points',
      'icon': Icons.star_outline,
      'route': '/points',
    },
    {
      'title': 'My Coupons',
      'icon': Icons.card_giftcard,
      'route': '/coupon',
    },
    {
      'title': 'Referral',
      'icon': Icons.people_outline,
      'route': '/referral',
    },
    {
      'title': 'Settings',
      'icon': Icons.settings_outlined,
      'route': '/setting',
    },
    {
      'title': 'About App',
      'icon': Icons.info_outline,
      'route': '/about-app',
    },
  ];

  void _navigateToPage(String pageName) {
    switch (pageName) {
      case 'Home':
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 'My Booking':
        Navigator.of(context).pushReplacementNamed('/my-booking');
        break;
      case 'Shop':
        Navigator.of(context).pushReplacementNamed('/shop');
        break;
      case 'User':
        // Already on user
        break;
    }
  }

  void _navigateToMenuItem(String route) {
    Navigator.of(context).pushNamed(route);
  }

  void _handleLogout() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform logout
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // User profile header
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _userData['name'],
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _userData['email'],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _userData['phone'],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 8),
                                Text(
                                  '${_userData['points']} Points',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Menu items
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _menuItems.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _menuItems[index];
                        return ListTile(
                          leading: Icon(item['icon']),
                          title: Text(item['title']),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _navigateToMenuItem(item['route']),
                        );
                      },
                    ),
                    
                    // Logout button
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Logout'),
                        ),
                      ),
                    ),
                  ],
                ),
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
}

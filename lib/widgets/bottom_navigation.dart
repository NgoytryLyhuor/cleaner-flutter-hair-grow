import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final String currentPage;
  final Function(String) onPageChanged;

  const BottomNavigation({
    Key? key,
    required this.currentPage,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F0F0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(
            context: context,
            name: 'Home',
            route: '/home',
            activeIcon: 'assets/icons/ic_selected_home.png',
            inactiveIcon: 'assets/icons/ic_unselected_home.png',
          ),
          _buildTabItem(
            context: context,
            name: 'My Booking',
            route: '/my-booking',
            activeIcon: 'assets/icons/ic_selected_booking.png',
            inactiveIcon: 'assets/icons/ic_unselected_booking.png',
          ),
          _buildTabItem(
            context: context,
            name: 'Shop',
            route: '/shop',
            activeIcon: 'assets/icons/ic_selected_shop.png',
            inactiveIcon: 'assets/icons/ic_unselected_shop.png',
          ),
          _buildTabItem(
            context: context,
            name: 'User',
            route: '/user',
            activeIcon: 'assets/icons/ic_selected_profile.png',
            inactiveIcon: 'assets/icons/ic_unselected_profile.png',
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required String name,
    required String route,
    required String activeIcon,
    required String inactiveIcon,
  }) {
    final bool isActive = currentPage == name;
    
    return InkWell(
      onTap: () => onPageChanged(name),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isActive ? activeIcon : inactiveIcon,
            width: 20,
            height: 20,
            color: isActive ? Colors.black : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

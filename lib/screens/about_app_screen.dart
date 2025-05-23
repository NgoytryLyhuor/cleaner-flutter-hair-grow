import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About App'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.content_cut,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                
                // App name and version
                Text(
                  'Hair Salon',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                
                // App description
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Hair Salon is a comprehensive booking application designed to streamline the process of scheduling hair appointments. Our app connects clients with professional stylists, offering a seamless booking experience with features like service selection, stylist profiles, real-time availability, and appointment management.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Features
                Text(
                  'Key Features',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildFeatureItem(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Easy Booking',
                  description: 'Book appointments with just a few taps',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.person,
                  title: 'Stylist Selection',
                  description: 'Choose your preferred stylist',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.spa,
                  title: 'Service Variety',
                  description: 'Wide range of hair services available',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.notifications,
                  title: 'Reminders',
                  description: 'Get notified about upcoming appointments',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.star,
                  title: 'Loyalty Program',
                  description: 'Earn points and redeem rewards',
                ),
                const SizedBox(height: 32),
                
                // Contact information
                Text(
                  'Contact Us',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  context,
                  icon: Icons.email,
                  title: 'Email',
                  value: 'support@hairsalon.com',
                ),
                _buildContactItem(
                  context,
                  icon: Icons.phone,
                  title: 'Phone',
                  value: '+1 234 567 8901',
                ),
                _buildContactItem(
                  context,
                  icon: Icons.language,
                  title: 'Website',
                  value: 'www.hairsalon.com',
                ),
                const SizedBox(height: 32),
                
                // Social media
                Text(
                  'Follow Us',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      context,
                      icon: Icons.facebook,
                      color: Colors.blue,
                      onTap: () {
                        // Open Facebook
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      context,
                      icon: Icons.camera_alt,
                      color: Colors.purple,
                      onTap: () {
                        // Open Instagram
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      context,
                      icon: Icons.message,
                      color: Colors.blue.shade300,
                      onTap: () {
                        // Open Twitter
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      context,
                      icon: Icons.video_library,
                      color: Colors.red,
                      onTap: () {
                        // Open YouTube
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Copyright
                Text(
                  '© 2025 Hair Salon. All rights reserved.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}

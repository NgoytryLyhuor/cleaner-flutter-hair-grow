import 'package:flutter/material.dart';

class SocialMediaScreen extends StatelessWidget {
  const SocialMediaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample social media platforms
    final List<Map<String, dynamic>> socialPlatforms = [
      {
        'name': 'Facebook',
        'icon': Icons.facebook,
        'color': Colors.blue,
        'username': '@hairsalon',
        'followers': '25.6K',
        'url': 'https://facebook.com/hairsalon',
      },
      {
        'name': 'Instagram',
        'icon': Icons.camera_alt,
        'color': Colors.purple,
        'username': '@hairsalon_official',
        'followers': '42.3K',
        'url': 'https://instagram.com/hairsalon_official',
      },
      {
        'name': 'Twitter',
        'icon': Icons.message,
        'color': Colors.blue.shade300,
        'username': '@hairsalon',
        'followers': '18.9K',
        'url': 'https://twitter.com/hairsalon',
      },
      {
        'name': 'YouTube',
        'icon': Icons.video_library,
        'color': Colors.red,
        'username': 'Hair Salon Official',
        'followers': '105K',
        'url': 'https://youtube.com/c/hairsalonofficial',
      },
      {
        'name': 'TikTok',
        'icon': Icons.music_note,
        'color': Colors.black,
        'username': '@hairsalon',
        'followers': '56.2K',
        'url': 'https://tiktok.com/@hairsalon',
      },
      {
        'name': 'Pinterest',
        'icon': Icons.push_pin,
        'color': Colors.red.shade700,
        'username': '@hairsalon_styles',
        'followers': '32.1K',
        'url': 'https://pinterest.com/hairsalon_styles',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Social Media'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
              ),
              child: Column(
                children: [
                  Text(
                    'Follow Us',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stay connected with us on social media for the latest updates, promotions, and hair inspiration!',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Social media platforms list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: socialPlatforms.length,
                itemBuilder: (context, index) {
                  final platform = socialPlatforms[index];
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Open social media platform
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening ${platform['name']}'),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Platform icon
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: platform['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                platform['icon'],
                                color: platform['color'],
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Platform details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    platform['name'],
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    platform['username'],
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${platform['followers']} followers',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Follow button
                            ElevatedButton(
                              onPressed: () {
                                // Open social media platform
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Opening ${platform['name']}'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: platform['color'],
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: const Text('Follow'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstLoadScreen extends StatefulWidget {
  const FirstLoadScreen({Key? key}) : super(key: key);

  @override
  State<FirstLoadScreen> createState() => _FirstLoadScreenState();
}

class _FirstLoadScreenState extends State<FirstLoadScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // fade out over 500ms
      vsync: this,
    );

    // Create fade animation (starts at 1.0, fades to 0.0)
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _startLoadingAndNavigate();
  }

  Future<void> _startLoadingAndNavigate() async {
    // Wait for loading time (like your original version)
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      // Start fade out animation
      await _animationController.forward();

      if (mounted) {
        // Check if this is first time user
        await _checkFirstLaunchAndNavigate();
      }
    }
  }

  Future<void> _checkFirstLaunchAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      // First time user - go to welcome screen
      Navigator.of(context).pushReplacementNamed('/welcome');
    } else {
      // Returning user - go directly to home
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6), // Match your app's theme
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Center(
              child: Image.asset(
                'assets/splash_screen_logo.png',
                width: 270,
                height: 270,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  print('Image loading error: $error');
                  return Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: Colors.grey.shade600,
                        ),
                        const Text('Image not found'),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
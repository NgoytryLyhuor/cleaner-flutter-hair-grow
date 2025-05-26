import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _textAnimationController;
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      image: 'assets/walk_img_1.png',
      title: 'Book & Manage your bookings',
      description:
      'Turn on notification and we\'ll remind you when your booking is coming',
      buttonText: 'Next',
    ),
    OnboardingData(
      image: 'assets/walk_img_2.png',
      title: 'Get coupon for discount',
      description:
      'Don\'t miss out on the chance to save big on your favorite services',
      buttonText: 'Next',
    ),
    OnboardingData(
      image: 'assets/walk_img_3.png',
      title: 'Earn Points by completing services',
      description:
      'Loyalty Points Program for Exclusive Discounts! growTokyo',
      buttonText: 'Get Started',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _textAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage < _onboardingData.length - 1) {
      _textAnimationController.reset();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete onboarding
      await _completeOnboarding();
    }
  }

  void _goToPage(int page) {
    if (page != _currentPage) {
      _textAnimationController.reset();
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() async {
    // Complete onboarding
    await _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    // Mark first launch as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);

    // Navigate to home with arguments to show modals
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(
        '/home',
        arguments: {'showModals': true},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Step 1: Big container that covers header and slide
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Stack(
              children: [
                // Step 2: Black header with background pattern
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage('assets/bg_pattern.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 40), // Balance for skip button
                              // Logo at top center
                              Image.asset(
                                'assets/logo_long.png',
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                              // Skip button at top right
                              GestureDetector(
                                onTap: _skip,
                                child: const Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Slide images that cover a little bit on header
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.15,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      _textAnimationController.reset();
                      _textAnimationController.forward();
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            _onboardingData[index].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Bottom content section
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // Animated text content
                  AnimatedBuilder(
                    animation: _textAnimationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textAnimationController.value,
                        child: Transform.translate(
                          offset: Offset(
                              0, 20 * (1 - _textAnimationController.value)),
                          child: Column(
                            children: [
                              Text(
                                _onboardingData[_currentPage].title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _onboardingData[_currentPage].description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Button
                  Container(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _onboardingData[_currentPage].buttonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                          (index) => GestureDetector(
                        onTap: () => _goToPage(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 30 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.black
                                : Colors.grey.shade300,
                            borderRadius: _currentPage == index
                                ? BorderRadius.circular(0)
                                : BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String description;
  final String buttonText;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
  });
}
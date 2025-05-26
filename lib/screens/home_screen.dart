import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/inquiry_modal.dart';
import '../widgets/country_selection_modal.dart';
import '../widgets/language_selection_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final String _currentPage = 'Home';
  final PageController _pageController = PageController();
  int _currentSlide = 0;
  bool _isLoading = false;
  late AnimationController _animationController;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;
  late List<Animation<double>> _fadeAnimations;

  // First launch modal variables
  bool _isFirstLaunch = false;
  String? _selectedCountry;
  String? _selectedLanguage;

  // Fixed: All slider images now have consistent full asset paths
  final List<String> _sliderImages = [
    'assets/slide1.jpg',
    'assets/slide2.jpg',
    'assets/slide3.jpg',
    'assets/slide4.jpg',
    'assets/slide5.jpg',
  ];

  final Map<String, dynamic> _userData = {
    'first_name': 'Kom',
    'last_name': 'C Speii',
    'credit': 2354.00,
    'country_code': 'Cambodia',
  };

  @override
  void initState() {
    super.initState();
    _setStatusBarColor();
    _checkFirstLaunch();
    _startAutoSlide();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Animation controller for the Book Appointment button
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));

    // Create 6 animations for the 6 action buttons (0.1s delay between each)
    _fadeAnimations = List.generate(6, (index) =>
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              0.1 * index,
              0.5 + 0.1 * index,
              curve: Curves.easeOut,
            ),
          ),
        ),
    );

    _animationController.forward();
  }

  // Check if this is the first launch
  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedSetup = prefs.getBool('has_completed_setup') ?? false;

    if (!hasCompletedSetup) {
      setState(() {
        _isFirstLaunch = true;
      });
      // Show country modal after a short delay to let the screen load
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _showCountrySelectionModal();
        }
      });
    }
  }

  // Show country selection modal using your existing modal
  void _showCountrySelectionModal() async {
    final selectedCountry = await showCountrySelectionModal(context);
    if (selectedCountry != null) {
      setState(() {
        _selectedCountry = selectedCountry;
      });
      // After country selection, show language modal
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _showLanguageSelectionModal();
        }
      });
    }
  }

  // Show language selection modal using your existing modal
  void _showLanguageSelectionModal() async {
    final selectedLanguage = await showLanguageSelectionModal(context);
    if (selectedLanguage != null) {
      setState(() {
        _selectedLanguage = selectedLanguage;
      });
      // Mark setup as completed
      _completeFirstLaunchSetup();
    }
  }

  // Complete first launch setup
  Future<void> _completeFirstLaunchSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_setup', true);

    // Save selected preferences
    if (_selectedCountry != null) {
      await prefs.setString('selected_country', _selectedCountry!);
    }
    if (_selectedLanguage != null) {
      await prefs.setString('selected_language', _selectedLanguage!);
    }

    setState(() {
      _isFirstLaunch = false;
    });

    // Show a welcome message after setup completion
    _showWelcomeMessage();
  }

  // Show welcome message after setup completion
  void _showWelcomeMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome! Setup completed successfully.',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _setStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _currentSlide = (_currentSlide + 1) % _sliderImages.length;
        });
        _pageController.animateToPage(
          _currentSlide,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
        _startAutoSlide();
      }
    });
  }

  void _navigateToPage(String pageName) {
    switch (pageName) {
      case 'Home':
        break;
      case 'My Booking':
        Navigator.of(context).pushReplacementNamed('/my-booking');
        break;
      case 'Shop':
        Navigator.of(context).pushReplacementNamed('/shop');
        break;
      case 'User':
        Navigator.of(context).pushReplacementNamed('/user');
        break;
    }
  }

  void _onBookAppointmentPressed() async {
    await _buttonAnimationController.forward();
    await _buttonAnimationController.reverse();
    Navigator.of(context).pushNamed('/branch');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPadding = 26.0;
    final gapBetweenButtons = 10.0;
    final buttonCountPerRow = 3;
    final actionButtonWidth = (screenWidth - (2 * screenPadding) - ((buttonCountPerRow - 1) * gapBetweenButtons)) / buttonCountPerRow;
    final actionButtonHeight = actionButtonWidth * 0.90;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 0, // Hides the AppBar but keeps status bar black
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(0),
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Builder(
                                  builder: (BuildContext context) {
                                    final mediaQuery = MediaQuery.of(context);
                                    final screenHeight = mediaQuery.size.height;
                                    final headerContentHeight = 60.0;
                                    final bannerOverlapSpace = 70.0;
                                    final minTopPadding = 35.0;
                                    final maxTopPadding = 60.0;
                                    final availableHeaderSpace = screenHeight * 0.18;

                                    final dynamicTopPadding = ((availableHeaderSpace - headerContentHeight - bannerOverlapSpace) / 2)
                                        .clamp(minTopPadding, maxTopPadding);

                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: dynamicTopPadding,
                                        bottom: bannerOverlapSpace,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${_userData['first_name']} ${_userData['last_name']}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Text('👋', style: TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                _userData['country_code'] ?? 'Cambodia',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/icons/ic_crown.png',
                                                      width: 20,
                                                      height: 20,
                                                      color: Colors.white,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return const Icon(
                                                          Icons.star,
                                                          size: 20,
                                                          color: Colors.white,
                                                        );
                                                      },
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      (_userData['credit'] as double).toStringAsFixed(2),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              Positioned(
                                top: 100,
                                left: 20,
                                right: 20,
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return FadeTransition(
                                      opacity: _fadeAnimations[0],
                                      child: Transform.translate(
                                        offset: Offset(0, 20 * (1 - _fadeAnimations[0].value)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 210,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xFFD4D4D4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: PageView.builder(
                                            controller: _pageController,
                                            onPageChanged: (index) {
                                              setState(() {
                                                _currentSlide = index;
                                              });
                                            },
                                            itemCount: _sliderImages.length,
                                            itemBuilder: (context, index) {
                                              return Image.asset(
                                                _sliderImages[index],
                                                width: double.infinity,
                                                height: 200,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey,
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          const Icon(Icons.error, color: Colors.red),
                                                          Text('Image not found\n${_sliderImages[index]}'),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          left: 0,
                                          right: 0,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate(
                                              _sliderImages.length,
                                                  (index) => AnimatedContainer(
                                                duration: const Duration(milliseconds: 500),
                                                curve: Curves.easeInOutCubic,
                                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                                width: _currentSlide == index ? 16 : 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4),
                                                  color: _currentSlide == index
                                                      ? Colors.white
                                                      : Colors.white.withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 320),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 20,
                            bottom: 20,
                          ),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: _fadeAnimations[1],
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - _fadeAnimations[1].value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: AnimatedBuilder(
                                    animation: _buttonScaleAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _buttonScaleAnimation.value,
                                        child: ElevatedButton(
                                          onPressed: _onBookAppointmentPressed,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icons/calendar.png',
                                                width: 25,
                                                height: 25,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Icon(
                                                    Icons.calendar_today,
                                                    size: 25,
                                                    color: Colors.white,
                                                  );
                                                },
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                'Book Appointment',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: _fadeAnimations[2],
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - _fadeAnimations[2].value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildActionButton(
                                        'assets/icons/points.png',
                                        'Points',
                                        actionButtonWidth,
                                        actionButtonHeight,
                                        screenWidth,
                                      ),
                                      _buildActionButton(
                                        'assets/icons/referral.png',
                                        'Referral',
                                        actionButtonWidth,
                                        actionButtonHeight,
                                        screenWidth,
                                      ),
                                      _buildActionButton(
                                        'assets/icons/coupon.png',
                                        'Coupon',
                                        actionButtonWidth,
                                        actionButtonHeight,
                                        screenWidth,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: _fadeAnimations[3],
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - _fadeAnimations[3].value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildActionButton(
                                        'assets/icons/product.png',
                                        'Product',
                                        actionButtonWidth,
                                        actionButtonHeight,
                                        screenWidth,
                                      ),
                                      _buildActionButton(
                                        'assets/icons/inquiry.png',
                                        'Inquiry',
                                        actionButtonWidth,
                                        actionButtonHeight,
                                        screenWidth,
                                      ),
                                      _buildActionButton(
                                        'assets/icons/notifications.png',
                                        'Notifications',
                                        actionButtonWidth,
                                        actionButtonHeight,
                                        screenWidth,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BottomNavigation(
                  currentPage: _currentPage,
                  onPageChanged: _navigateToPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String iconPath,
      String label,
      double width,
      double height,
      double screenWidth,
      ) {
    final Map<String, IconData> fallbackIcons = {
      'Points': Icons.star,
      'Referral': Icons.people,
      'Coupon': Icons.local_offer,
      'Product': Icons.shopping_bag,
      'Inquiry': Icons.help,
      'Notifications': Icons.notifications,
    };

    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Points':
            Navigator.of(context).pushNamed('/points');
            break;
          case 'Referral':
            Navigator.of(context).pushNamed('/referral');
            break;
          case 'Coupon':
            Navigator.of(context).pushNamed('/coupon');
            break;
          case 'Inquiry':
          // Show the inquiry modal instead of navigating
            showInquiryModal(context);
            break;
          case 'Notifications':
            Navigator.of(context).pushNamed('/notifications');
            break;
        }
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  fallbackIcons[label] ?? Icons.image_not_supported,
                  size: 40,
                  color: Colors.grey.shade600,
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
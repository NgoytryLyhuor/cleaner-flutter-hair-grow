import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasAnimated = false;
  late AnimationController _animationController;
  late AnimationController _shimmerController;
  late AnimationController _staggeredController;
  final List<AnimationController> _cardAnimationControllers = [];
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  // Current selections
  String _selectedCountry = 'Cambodia';
  String _selectedLanguage = 'English';

  // Settings data
  final List<Map<String, dynamic>> _settings = [
    {
      'id': '1',
      'title': 'Language',
      'icon': 'assets/icons/ic_app_language.png',
      'onTap': 'language',
    },
    {
      'id': '2',
      'title': 'Country',
      'icon': 'assets/icons/ic_app_language.png',
      'onTap': 'country',
    },
    {
      'id': '3',
      'title': 'Change Password',
      'icon': 'assets/icons/ic_lock.png',
      'onTap': 'password',
    },
    {
      'id': '4',
      'title': 'Delete Account',
      'icon': 'assets/icons/ic_delete_account.png',
      'onTap': 'delete',
      'isDestructive': true,
    },
  ];

  // Countries data
  final List<Map<String, dynamic>> _countries = [
    {
      'name': 'Cambodia',
      'code': 'KH',
      'flag': 'assets/ic_km.png',
    },
    {
      'name': 'Vietnam',
      'code': 'VN',
      'flag': 'assets/ic_vi.png',
    },
  ];

  // Languages data
  final List<Map<String, dynamic>> _languages = [
    {
      'name': 'English',
      'code': 'en',
      'flag': 'assets/ic_us.png',
    },
    {
      'name': 'Khmer',
      'code': 'km',
      'flag': 'assets/ic_km.png',
    },
    {
      'name': 'Vietnamese',
      'code': 'vi',
      'flag': 'assets/ic_vi.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    print('SettingScreen: initState called, _isLoading = $_isLoading');

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    // Controller for staggered animations
    _staggeredController = AnimationController(
      duration: Duration(milliseconds: 200 + (_settings.length * 100)),
      vsync: this,
    );

    // Initialize individual card animations
    _initializeCardAnimations();

    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 500), () {
      print('SettingScreen: Loading timer completed');
      if (mounted) {
        print('SettingScreen: Widget is mounted, setting _isLoading to false');
        setState(() {
          _isLoading = false;
        });

        // Start the staggered animation after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && !_hasAnimated) {
            _hasAnimated = true;
            _startCardAnimations();
          }
        });
      } else {
        print('SettingScreen: Widget is not mounted');
      }
    });
  }

  void _initializeCardAnimations() {
    for (int i = 0; i < _settings.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );

      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));

      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));

      _cardAnimationControllers.add(controller);
      _slideAnimations.add(slideAnimation);
      _fadeAnimations.add(fadeAnimation);
    }
  }

  void _startCardAnimations() async {
    for (int i = 0; i < _cardAnimationControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 100));
      if (mounted) {
        _cardAnimationControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    _staggeredController.dispose();
    for (final controller in _cardAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildSkeletonCard();
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              // Left side - Icon skeleton
              _buildShimmerBox(width: 24, height: 24, borderRadius: 4),
              const SizedBox(width: 16),

              // Right side - Title skeleton
              Expanded(
                child: _buildShimmerBox(width: double.infinity, height: 16),
              ),

              // Right arrow skeleton
              _buildShimmerBox(width: 16, height: 16, borderRadius: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double borderRadius = 4,
  }) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _shimmerController.value * 2, 0.0),
              end: Alignment(1.0 + _shimmerController.value * 2, 0.0),
            ),
          ),
        );
      },
    );
  }

  void _handleSettingTap(String action, String title) {
    switch (action) {
      case 'language':
        _showLanguageSelector();
        break;
      case 'country':
        _showCountrySelector();
        break;
      case 'password':
        _showPasswordChange();
        break;
      case 'delete':
        _showDeleteAccountConfirmation();
        break;
    }
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLanguageModal(),
    );
  }

  void _showCountrySelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCountryModal(),
    );
  }

  void _showPasswordChange() {
    // Navigate to password change screen or show modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Change Password')),
    );
  }

  void _showDeleteAccountConfirmation() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink(); // Placeholder for transitionBuilder
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ));

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ));

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEEBEA),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/ic_profile_delete.png',
                          width: 40,
                          height: 40,
                          color: Color(0xFFE53E3E),
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.logout,
                              color: Color(0xFFE53E3E),
                              size: 32,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Your data will not be able to be restored after the deletion!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3748),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FAFC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF4A5568),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A202C),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _performLogout(); // Your delete logic
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
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
        );
      },
    );
  }

  // Add this method to handle the actual logout
  void _performLogout() {
    // Add your logout logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account Deleted...'),
        backgroundColor: Color(0xFFE53E3E),
      ),
    );

    // Example: Navigate to login screen
    // Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget _buildLanguageModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Languages list
          Expanded(
            child: ListView.builder(
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index];
                final isSelected = language['name'] == _selectedLanguage;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          language['flag']!,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.language,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      language['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 24,
                    )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedLanguage = language['name']!;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected: ${language['name']}')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Country',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Countries list
          Expanded(
            child: ListView.builder(
              itemCount: _countries.length,
              itemBuilder: (context, index) {
                final country = _countries[index];
                final isSelected = country['name'] == _selectedCountry;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          country['flag']!,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.flag,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      country['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 24,
                    )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCountry = country['name']!;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected: ${country['name']}')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard(Map<String, dynamic> setting, int index) {
    final isDestructive = setting['isDestructive'] ?? false;

    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => _handleSettingTap(setting['onTap'], setting['title']),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  children: [
                    // Left side - Setting icon
                    Image.asset(
                      setting['icon'],
                      width: 24,
                      height: 24,
                      color: isDestructive ? Colors.red : Colors.grey[600],
                      errorBuilder: (context, error, stackTrace) {
                        IconData fallbackIcon;
                        switch (setting['onTap']) {
                          case 'language':
                          case 'country':
                            fallbackIcon = Icons.language;
                            break;
                          case 'password':
                            fallbackIcon = Icons.lock_outline;
                            break;
                          case 'delete':
                            fallbackIcon = Icons.delete_outline;
                            break;
                          case 'logout':
                            fallbackIcon = Icons.logout;
                            break;
                          default:
                            fallbackIcon = Icons.settings;
                        }
                        return Icon(
                          fallbackIcon,
                          color: isDestructive ? Colors.red : Colors.grey[600],
                          size: 24,
                        );
                      },
                    ),

                    const SizedBox(width: 16),

                    // Middle - Setting title
                    Expanded(
                      child: Text(
                        setting['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDestructive ? Colors.red : Colors.black87,
                        ),
                      ),
                    ),

                    // Right side - Arrow icon
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('SettingScreen: build called, _isLoading = $_isLoading');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Custom header with back button
          const CustomHeader(
            title: 'Setting',
          ),

          // Settings list
          Expanded(
            child: _isLoading
                ? _buildSkeletonList()
                : _settings.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _settings.length,
              itemBuilder: (context, index) {
                final setting = _settings[index];
                return _buildSettingCard(setting, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Center(
              child: Icon(
                Icons.settings_outlined,
                color: Colors.grey,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Settings Available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Settings will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
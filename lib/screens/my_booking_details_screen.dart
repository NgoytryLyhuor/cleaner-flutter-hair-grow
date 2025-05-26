import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';

class MyBookingDetailsScreen extends StatefulWidget {
  const MyBookingDetailsScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingDetailsScreen> createState() => _MyBookingDetailsScreenState();
}

class _MyBookingDetailsScreenState extends State<MyBookingDetailsScreen>
    with TickerProviderStateMixin {
  bool _hasAnimated = false;
  bool _usePoints = false;
  final TextEditingController _referralController = TextEditingController();

  // Animation controllers
  late AnimationController _staggeredController;
  final List<AnimationController> _sectionAnimationControllers = [];
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  // Sample booking information with null safety
  final Map<String, dynamic> _bookingInfo = {
    'name': 'My Developer Testing',
    'contactNumber': '123456789',
    'dateTime': '2025-05-28 at 10:30',
    'branchName': 'grow Tokyo BKK',
    'stylist': 'Mochi',
    'description': 'Cut (For Men)',
    'image': 'assets/services/cut-man.jpg',
  };

  // Section titles for animation
  final List<String> _sections = [
    'Your Information',
    'Time Slot',
    'Location Information',
    'Stylist',
    'Services',
    'Services Note (optional)',
  ];

  @override
  void initState() {
    super.initState();
    print('MyBookingDetailsScreen: initState called');

    // Controller for staggered animations
    _staggeredController = AnimationController(
      duration: Duration(milliseconds: 200 + (_sections.length * 100)),
      vsync: this,
    );

    // Initialize individual section animations
    _initializeSectionAnimations();

    // Start the staggered animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && !_hasAnimated) {
        _hasAnimated = true;
        _startSectionAnimations();
      }
    });
  }

  void _initializeSectionAnimations() {
    for (int i = 0; i < _sections.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );

      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.0, 0.3),
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

      _sectionAnimationControllers.add(controller);
      _slideAnimations.add(slideAnimation);
      _fadeAnimations.add(fadeAnimation);
    }
  }

  void _startSectionAnimations() async {
    for (int i = 0; i < _sectionAnimationControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 80));
      if (mounted) {
        _sectionAnimationControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    _referralController.dispose();
    _staggeredController.dispose();
    for (final controller in _sectionAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }



  void _confirmBooking() {
    // Simulate API call - you can add loading state here if needed
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Navigate to success screen or show success dialog
        _showSuccessDialog();
      }
    });
  }

  void _showReferralCodeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Referral Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Input field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _referralController,
                  decoration: const InputDecoration(
                    hintText: 'Referral Code',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Apply button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle apply referral code
                    Navigator.pop(context);
                    // You can add your referral code logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Booking Successful!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your appointment has been booked successfully.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(int index, String title, Widget content) {
    if (index >= _slideAnimations.length) return Container();

    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(title),
            const SizedBox(height: 8),
            content,
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('MyBookingDetailsScreen: build called');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Custom Header
          const CustomHeader(
            title: '#3455',
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Your Information Section
                  _buildAnimatedSection(
                    0,
                    'Your Information',
                    _buildInfoCard([
                      _buildInfoRow('Name', _bookingInfo['name'] ?? 'N/A'),
                      _buildInfoRow('Contact Number', _bookingInfo['contactNumber'] ?? 'N/A'),
                    ]),
                  ),

                  // Time Slot Section
                  _buildAnimatedSection(
                    1,
                    'Time Slot',
                    _buildInfoCard([
                      _buildInfoRow('Date & Time', _bookingInfo['dateTime'] ?? 'N/A'),
                    ]),
                  ),

                  // Location Information Section
                  _buildAnimatedSection(
                    2,
                    'Location Information',
                    _buildInfoCard([
                      _buildInfoRow('Branch Name', _bookingInfo['branchName'] ?? 'N/A')
                    ]),
                  ),

                  // Stylist Section
                  _buildAnimatedSection(
                    3,
                    'Stylist',
                    _buildInfoCard([
                      _buildInfoRow('Stylist', _bookingInfo['stylist'] ?? 'N/A'),
                    ]),
                  ),

                  // Services Section
                  _buildAnimatedSection(
                    4,
                    'Services',
                    _buildServiceWithImageCard(),
                  ),

                  // Services Note Section
                  _buildAnimatedSection(
                    5,
                    'Services Note (optional)',
                    _buildServiceNoteCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceWithImageCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  _bookingInfo['image'] ?? 'assets/services/cut-man.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.content_cut,
                        color: Colors.grey,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Service Description
            Expanded(
              child: Text(
                _bookingInfo['description'] ?? 'No description available',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceNoteCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Text(
                'hello kon papa',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for number formatting
import '../widgets/custom_header.dart'; // Using same header as BranchScreen

class PointsScreen extends StatefulWidget {
  const PointsScreen({Key? key}) : super(key: key);

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  AnimationController? _animationController;
  AnimationController? _listAnimationController;
  Animation<double>? _slideAnimation;
  Animation<double>? _fadeAnimation;

  // Sample points data
  final int totalPoints = 2354;
  final String equivalentValue = "\$35.31";

  final List<Map<String, dynamic>> _allHistory = [
    {
      'id': '1',
      'date': '10/05/2025',
      'description': 'Growtokyo_awarded',
      'subtitle': 'Points awarded',
      'points': 2354,
      'type': 'earned',
    },
    {
      'id': '2',
      'date': '08/05/2025',
      'description': 'Booking completed',
      'subtitle': 'Hair cut service',
      'points': 150,
      'type': 'earned',
    },
    {
      'id': '3',
      'date': '05/05/2025',
      'description': 'Discount redeemed',
      'subtitle': '20% off haircut',
      'points': 300,
      'type': 'used',
    },
    {
      'id': '4',
      'date': '02/05/2025',
      'description': 'Referral bonus',
      'subtitle': 'Friend joined',
      'points': 200,
      'type': 'earned',
    },
    {
      'id': '5',
      'date': '28/04/2025',
      'description': 'Free treatment redeemed',
      'subtitle': 'Hair treatment',
      'points': 500,
      'type': 'used',
    },
    {
      'id': '6',
      'date': '25/04/2025',
      'description': 'Welcome bonus',
      'subtitle': 'New member reward',
      'points': 100,
      'type': 'earned',
    },
    {
      'id': '7',
      'date': '20/04/2025',
      'description': 'Booking completed',
      'subtitle': 'Color treatment',
      'points': 250,
      'type': 'earned',
    },
    {
      'id': '8',
      'date': '15/04/2025',
      'description': 'Gift card redeemed',
      'subtitle': 'Birthday special',
      'points': 1000,
      'type': 'used',
    },
  ];

  List<Map<String, dynamic>> get _filteredHistory {
    if (_tabController == null) return _allHistory;

    switch (_tabController!.index) {
      case 0: // History (All)
        return _allHistory;
      case 1: // Earned
        return _allHistory.where((item) => item['type'] == 'earned').toList();
      case 2: // Used
        return _allHistory.where((item) => item['type'] == 'used').toList();
      default:
        return _allHistory;
    }
  }

  String formatPoints(int points) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(points.toDouble());
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController?.addListener(() {
      if (_tabController!.indexIsChanging) {
        // Only animate when tab is actually changing, not during the animation process
        _listAnimationController?.reset();
        _listAnimationController?.forward();
        setState(() {}); // Rebuild when tab changes
      }
    });

    // Initialize animation controller for points card
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize animation controller for history list
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create slide animation (from bottom to top)
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOutCubic,
    ));

    // Create fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOut,
    ));

    // Start animations when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController?.forward();
      // Start list animation after a small delay
      Future.delayed(const Duration(milliseconds: 400), () {
        _listAnimationController?.forward();
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _animationController?.dispose();
    _listAnimationController?.dispose();
    super.dispose();
  }

  Widget _buildAnimatedHistoryItem(Map<String, dynamic> item, int index) {
    return AnimatedBuilder(
      animation: _listAnimationController!,
      builder: (context, child) {
        final animationValue = Curves.easeOutCubic.transform(
          (_listAnimationController!.value - (index * 0.1)).clamp(0.0, 1.0),
        );

        return Transform.translate(
          offset: Offset(0, (1 - animationValue) * 30),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Description and date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['description'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['subtitle'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['date'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Points
                  Text(
                    item['type'] == 'earned' ? '+${item['points']}' : '-${item['points']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: item['type'] == 'earned' ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Use same header as BranchScreen
          const CustomHeader(
            title: 'Points',
          ),

          // Animated Points Card
          AnimatedBuilder(
            animation: _animationController!,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation?.value ?? 0),
                child: Opacity(
                  opacity: _fadeAnimation?.value ?? 0,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // Background image
                          Positioned.fill(
                            child: Image.asset(
                              'assets/points_banner_bg.png',
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Dark overlay for better text readability
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Content
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Membership text and logo
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'MEMBERSHIP POINTS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    // Logo image
                                    Image.asset(
                                      'assets/logo_long.png',
                                      height: 22,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 30),

                                // Points section
                                Row(
                                  children: [
                                    // Crown icon
                                    Container(
                                      width: 40,
                                      height: 40,
                                      child: Center(
                                        child: Image.asset(
                                          'assets/icons/ic_crown.png',
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.contain,
                                          color: Colors.white, // This applies a white color filter
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Points number and text
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatPoints(totalPoints),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Equivalent to $equivalentValue',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: _tabController == null ? const SizedBox.shrink() : TabBar(
              controller: _tabController!,
              indicatorColor: Colors.black,
              indicatorWeight: 1,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              // Remove background color on tap
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              // Remove default divider
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'History'),
                Tab(text: 'Earned'),
                Tab(text: 'Used'),
              ],
            ),
          ),

          // History List with Animation
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredHistory.length,
                itemBuilder: (context, index) {
                  final item = _filteredHistory[index];
                  return _buildAnimatedHistoryItem(item, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
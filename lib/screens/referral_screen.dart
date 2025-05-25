import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen>
    with TickerProviderStateMixin {
  final String _referralCode = 'wdJpe98dL';
  final String _appDownloadLink = 'https://play.google.com/store/apps/details?id=com.hairsalon.app'; // Replace with your actual app link

  // Animation controllers (only for button press)
  late AnimationController _scaleController;

  // Animations
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setStatusBarColor();
    _initAnimations();
  }

  void _initAnimations() {
    // Scale animation for button press only
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
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

  void _copyReferralCode() async {
    // Scale animation for button feedback
    await _scaleController.forward();
    _scaleController.reverse();

    // Copy to clipboard
    await Clipboard.setData(ClipboardData(text: _referralCode));

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referral code copied to clipboard!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _shareReferralCode() async {
    final String shareText = 'Join Hair Salon using my referral code: $_referralCode\nDownload the app: $_appDownloadLink';

    // Show share options
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => _buildShareOptions(shareText),
    );
  }

  Widget _buildShareOptions(String shareText) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Share with',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Share options grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              _buildShareOption(
                'Facebook',
                Icons.facebook,
                Colors.blue,
                    () => _shareToFacebook(shareText),
              ),
              _buildShareOption(
                'Telegram',
                Icons.telegram,
                Colors.blue.shade400,
                    () => _shareToTelegram(shareText),
              ),
              _buildShareOption(
                'WhatsApp',
                Icons.message,
                Colors.green,
                    () => _shareToWhatsApp(shareText),
              ),
              _buildShareOption(
                'Instagram',
                Icons.camera_alt,
                Colors.purple,
                    () => _shareToInstagram(shareText),
              ),
              _buildShareOption(
                'Twitter',
                Icons.alternate_email,
                Colors.lightBlue,
                    () => _shareToTwitter(shareText),
              ),
              _buildShareOption(
                'LinkedIn',
                Icons.business,
                Colors.blue.shade800,
                    () => _shareToLinkedIn(shareText),
              ),
              _buildShareOption(
                'SMS',
                Icons.sms,
                Colors.orange,
                    () => _shareViaSMS(shareText),
              ),
              _buildShareOption(
                'More',
                Icons.share,
                Colors.grey,
                    () => _shareGeneral(shareText),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildShareOption(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _shareToFacebook(String text) async {
    Navigator.pop(context);

    // Try Facebook app first, then web
    final List<String> facebookUrls = [
      'fb://facewebmodal/f?href=${Uri.encodeComponent(_appDownloadLink)}&quote=${Uri.encodeComponent(text)}',
      'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(_appDownloadLink)}&quote=${Uri.encodeComponent(text)}',
    ];

    bool shared = false;
    for (String urlString in facebookUrls) {
      try {
        final Uri url = Uri.parse(urlString);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          shared = true;
          break;
        }
      } catch (e) {
        continue;
      }
    }

    if (!shared) {
      await Share.share(text);
    }
  }

  void _shareToTelegram(String text) async {
    Navigator.pop(context);

    // Try Telegram app first, then web
    final List<String> telegramUrls = [
      'tg://msg?text=${Uri.encodeComponent(text)}',
      'https://t.me/share/url?url=${Uri.encodeComponent(_appDownloadLink)}&text=${Uri.encodeComponent(text)}',
    ];

    bool shared = false;
    for (String urlString in telegramUrls) {
      try {
        final Uri url = Uri.parse(urlString);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          shared = true;
          break;
        }
      } catch (e) {
        continue;
      }
    }

    if (!shared) {
      await Share.share(text);
    }
  }

  void _shareToWhatsApp(String text) async {
    Navigator.pop(context);

    // Try WhatsApp app first, then web
    final List<String> whatsappUrls = [
      'whatsapp://send?text=${Uri.encodeComponent(text)}',
      'https://wa.me/?text=${Uri.encodeComponent(text)}',
    ];

    bool shared = false;
    for (String urlString in whatsappUrls) {
      try {
        final Uri url = Uri.parse(urlString);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          shared = true;
          break;
        }
      } catch (e) {
        continue;
      }
    }

    if (!shared) {
      await Share.share(text);
    }
  }

  void _shareToInstagram(String text) async {
    Navigator.pop(context);

    // Instagram doesn't support direct text sharing, so we open the app or fallback to general share
    final List<String> instagramUrls = [
      'instagram://story-camera',
      'https://www.instagram.com/',
    ];

    bool opened = false;
    for (String urlString in instagramUrls) {
      try {
        final Uri url = Uri.parse(urlString);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          opened = true;
          break;
        }
      } catch (e) {
        continue;
      }
    }

    if (!opened) {
      await Share.share(text);
    }
  }

  void _shareToTwitter(String text) async {
    Navigator.pop(context);

    // Try Twitter app first, then web
    final List<String> twitterUrls = [
      'twitter://post?message=${Uri.encodeComponent(text)}',
      'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(text)}&url=${Uri.encodeComponent(_appDownloadLink)}',
    ];

    bool shared = false;
    for (String urlString in twitterUrls) {
      try {
        final Uri url = Uri.parse(urlString);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          shared = true;
          break;
        }
      } catch (e) {
        continue;
      }
    }

    if (!shared) {
      await Share.share(text);
    }
  }

  void _shareToLinkedIn(String text) async {
    Navigator.pop(context);

    // LinkedIn sharing
    final List<String> linkedinUrls = [
      'linkedin://sharing?message=${Uri.encodeComponent(text)}',
      'https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent(_appDownloadLink)}&title=${Uri.encodeComponent('Hair Salon Referral')}&summary=${Uri.encodeComponent(text)}',
    ];

    bool shared = false;
    for (String urlString in linkedinUrls) {
      try {
        final Uri url = Uri.parse(urlString);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          shared = true;
          break;
        }
      } catch (e) {
        continue;
      }
    }

    if (!shared) {
      await Share.share(text);
    }
  }

  void _shareViaSMS(String text) async {
    Navigator.pop(context);

    // SMS sharing
    try {
      final Uri smsUrl = Uri.parse('sms:?body=${Uri.encodeComponent(text)}');
      if (await canLaunchUrl(smsUrl)) {
        await launchUrl(smsUrl);
      } else {
        await Share.share(text);
      }
    } catch (e) {
      await Share.share(text);
    }
  }

  void _shareGeneral(String text) async {
    Navigator.pop(context);
    try {
      await Share.share(text, subject: 'Hair Salon Referral');
    } catch (e) {
      // Handle error silently
    }
  }

  void _showHowItWorksModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildHowItWorksModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header section with black background
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 90,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Referral',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 36),
                        ],
                      ),
                    ),

                    // White referral card (no animations)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      transform: Matrix4.translationValues(0, -40, 0),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'YOUR REFERRAL CODE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _referralCode,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Copy and Share buttons
                          Row(
                            children: [
                              // Animated Copy button (only button animation remains)
                              Expanded(
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Container(
                                    height: 48,
                                    margin: const EdgeInsets.only(right: 8),
                                    child: OutlinedButton.icon(
                                      onPressed: _copyReferralCode,
                                      icon: const Icon(
                                        Icons.copy,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      label: const Text(
                                        'Copy Code',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.grey),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Share button
                              Expanded(
                                child: Container(
                                  height: 48,
                                  margin: const EdgeInsets.only(left: 8),
                                  child: ElevatedButton.icon(
                                    onPressed: _shareReferralCode,
                                    icon: const Icon(
                                      Icons.share,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Share',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E3A8A),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // How it works section
                          GestureDetector(
                            onTap: _showHowItWorksModal,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/referral_reward.png',
                                  width: 32,
                                  height: 32,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.card_giftcard,
                                      size: 32,
                                      color: Colors.orange,
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Invite new customers to get points',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'How it works?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Reward History section (no animations)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reward History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // No transaction found with GIF
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Using the custom GIF instead of icon
                                Image.asset(
                                  'assets/icons/empty_lottie.gif',
                                  width: 150,
                                  height: 150,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.search,
                                      size: 60,
                                      color: Colors.grey.shade400,
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Transaction Found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksModal() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Modal header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'How it works?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Steps with custom icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildStep(
                  'assets/icons/ic_send_2.png',
                  'Share your referral code to your friends.',
                ),
                const SizedBox(height: 16),
                _buildStep(
                  'assets/icons/ic_percentage_square.png',
                  'Your friends booking an appointment and apply your code to receive a discount.',
                ),
                const SizedBox(height: 16),
                _buildStep(
                  'assets/icons/ic_crown.png',
                  'After your friend\'s booking is completed, you will receive points as a reward.',
                ),
                const SizedBox(height: 24),

                // Warning note with dashed border
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomPaint(
                    painter: DashedBorderPainter(
                      color: Colors.orange.shade300,
                      strokeWidth: 2,
                      dashWidth: 8,
                      dashSpace: 5,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: const Text(
                        'Each referral code can only be used once per people.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String iconPath, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(
            iconPath,
            width: 20,
            height: 20,
            errorBuilder: (context, error, stackTrace) {
              // Fallback icons if assets don't load
              IconData fallbackIcon;
              if (iconPath.contains('send')) {
                fallbackIcon = Icons.share;
              } else if (iconPath.contains('percentage')) {
                fallbackIcon = Icons.discount;
              } else {
                fallbackIcon = Icons.emoji_events;
              }
              return Icon(
                fallbackIcon,
                size: 20,
                color: Colors.grey.shade600,
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for dashed border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 2,
    this.dashWidth = 8,
    this.dashSpace = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ));

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0;
      while (distance < pathMetric.length) {
        final nextDistance = distance + dashWidth;
        final extractPath = pathMetric.extractPath(
          distance,
          nextDistance > pathMetric.length ? pathMetric.length : nextDistance,
        );
        canvas.drawPath(extractPath, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InquiryModal extends StatefulWidget {
  const InquiryModal({Key? key}) : super(key: key);

  @override
  State<InquiryModal> createState() => _InquiryModalState();
}

class _InquiryModalState extends State<InquiryModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  String? _selectedApp;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectApp(String app) {
    setState(() {
      _selectedApp = app;
    });
  }

  void _closeModal() async {
    await _animationController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleSelect() async {
    if (_selectedApp != null) {
      // Handle the selected app action
      switch (_selectedApp) {
        case 'Telegram':
          _launchTelegram();
          break;
        case 'Facebook':
          _launchFacebook();
          break;
      }
      _closeModal();
    }
  }

  void _launchTelegram() async {
    const telegramUrl = 'https://t.me/your_telegram_username';
    if (await canLaunchUrl(Uri.parse(telegramUrl))) {
      await launchUrl(Uri.parse(telegramUrl));
    }
  }

  void _launchFacebook() async {
    const facebookUrl = 'https://m.me/your_facebook_page';
    if (await canLaunchUrl(Uri.parse(facebookUrl))) {
      await launchUrl(Uri.parse(facebookUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              color: Colors.black.withOpacity(0.5 * _opacityAnimation.value),
              child: Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with close button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Inquiry',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: _closeModal,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  size: 24,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Description text
                        const Text(
                          'Please select the app you want to chat with us.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        // App selection buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildAppButton(
                                'Telegram',
                                'assets/icons/ic_telegram.png',
                                const Color(0xFF0088CC),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildAppButton(
                                'Facebook',
                                'assets/icons/ic_facebook_colored.png',
                                const Color(0xFF1877F2),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Select button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _selectedApp != null ? _handleSelect : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedApp != null
                                  ? Colors.black
                                  : Colors.grey.shade300,
                              foregroundColor: _selectedApp != null
                                  ? Colors.white
                                  : Colors.grey.shade500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Select',
                              style: TextStyle(
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
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppButton(String name, String iconPath, Color backgroundColor) {
    final bool isSelected = _selectedApp == name;

    return GestureDetector(
      onTap: () => _selectApp(name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? backgroundColor.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? backgroundColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 50,
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the modal
void showInquiryModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (context, animation, secondaryAnimation) {
      return const InquiryModal();
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
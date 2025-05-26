import 'package:flutter/material.dart';

class CountrySelectionModal extends StatefulWidget {
  const CountrySelectionModal({Key? key}) : super(key: key);

  @override
  State<CountrySelectionModal> createState() => _CountrySelectionModalState();
}

class _CountrySelectionModalState extends State<CountrySelectionModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  String? _selectedCountry;

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

  void _selectCountry(String country) {
    setState(() {
      _selectedCountry = country;
    });
  }

  void _closeModal() async {
    await _animationController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleSelect() async {
    if (_selectedCountry != null) {
      // Return the selected country to the parent widget
      Navigator.of(context).pop(_selectedCountry);
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
              color: Colors.black.withOpacity(0.1 * _opacityAnimation.value),
              child: Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        const Text(
                          'Select Country',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Country selection buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildCountryButton(
                                'Cambodia',
                                'assets/ic_km.png',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildCountryButton(
                                'Vietnam',
                                'assets/ic_vi.png',
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
                            onPressed: _selectedCountry != null ? _handleSelect : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedCountry != null
                                  ? Colors.black
                                  : Colors.grey.shade300,
                              foregroundColor: _selectedCountry != null
                                  ? Colors.white
                                  : Colors.grey.shade500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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

  Widget _buildCountryButton(String name, String flagPath) {
    final bool isSelected = _selectedCountry == name;

    return GestureDetector(
      onTap: () => _selectCountry(name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.shade50
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // Flag container with circular background
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    flagPath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the country selection modal
Future<String?> showCountrySelectionModal(BuildContext context) {
  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (context, animation, secondaryAnimation) {
      return const CountrySelectionModal();
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

// Example usage:
// void _showCountryModal() async {
//   final selectedCountry = await showCountrySelectionModal(context);
//   if (selectedCountry != null) {
//     print('Selected country: $selectedCountry');
//     // Handle the selected country
//   }
// }
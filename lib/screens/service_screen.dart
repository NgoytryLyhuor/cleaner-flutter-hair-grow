import 'package:flutter/material.dart';
import '../widgets/progress_header.dart';
import '../widgets/footer_button.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with TickerProviderStateMixin {

  final List<ServiceCategory> _serviceCategories = [
    ServiceCategory(
      title: 'CUT INC SHAMPOO and BLOW DRY',
      subServices: [
        SubService(
          title: 'Cut (For Men)',
          description: 'Professional haircut for men with styling',
          imagePath: 'assets/services/cut-man.jpg',
        ),
        SubService(
          title: 'Cut (For Lady)',
          description: 'Elegant haircut for women with precision styling',
          imagePath: 'assets/services/cut-women.jpg',
        ),
        SubService(
          title: 'Cut (For Kids under 10 years)',
          description: 'Fun and safe haircuts for kids with patient care',
          imagePath: 'assets/services/cut-kid.jpg',
        ),
        SubService(
          title: 'Beard Trim & Shape',
          description: 'Professional beard trimming and shaping service',
          imagePath: 'assets/services/bleach.jpg',
        ),
      ],
    ),
    ServiceCategory(
      title: 'SHAMPOO and BLOW DRY',
      subServices: [
        SubService(
          title: 'Deep Cleansing Shampoo',
          description: 'Thorough hair cleansing with premium products',
          imagePath: 'assets/services/shampoo.jpg',
        ),
        SubService(
          title: 'Moisturizing Treatment',
          description: 'Hydrating shampoo treatment for dry hair',
          imagePath: 'assets/services/shampoo.jpg',
        ),
        SubService(
          title: 'Volume Boost Blow Dry',
          description: 'Professional blow dry for maximum volume',
          imagePath: 'assets/services/shampoo.jpg',
        ),
      ],
    ),
    ServiceCategory(
      title: 'COLOR',
      subServices: [
        SubService(
          title: 'Full Hair Coloring',
          description: 'Complete hair color transformation',
          imagePath: 'assets/services/shampoo.jpg',
        ),
        SubService(
          title: 'Highlights & Lowlights',
          description: 'Strategic highlighting for natural dimension',
          imagePath: 'assets/services/shampoo.jpg',
        ),
        SubService(
          title: 'Root Touch-up',
          description: 'Quick root color maintenance service',
          imagePath: 'assets/services/shampoo.jpg',
        ),
        SubService(
          title: 'Balayage Technique',
          description: 'Hand-painted highlights for natural look',
          imagePath: 'assets/services/shampoo.jpg',
        ),
        SubService(
          title: 'Color Correction',
          description: 'Professional color correction and repair',
          imagePath: 'assets/services/shampoo.jpg',
        ),
      ],
    ),
    ServiceCategory(
      title: 'STYLING & TREATMENTS',
      subServices: [
        SubService(
          title: 'Hair Straightening',
          description: 'Professional keratin straightening treatment',
          imagePath: 'assets/services/shampoo.jpg',
        ),
        SubService(
          title: 'Perm & Curling',
          description: 'Create beautiful curls and waves',
          imagePath: 'assets/services/shampoo.jpg',
        ),
        SubService(
          title: 'Hair Mask Treatment',
          description: 'Deep conditioning mask for healthy hair',
          imagePath: 'assets/services/shampoo.jpg',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toggleCategoryExpansion(int index) {
    setState(() {
      _serviceCategories[index].isExpanded = !_serviceCategories[index].isExpanded;
    });
  }

  void _toggleServiceSelection(ServiceCategory category, SubService subService) {
    setState(() {
      // Allow multiple selections - remove the deselection logic
      subService.isSelected = !subService.isSelected;
    });
  }

  List<SubService> _getSelectedServices() {
    List<SubService> selectedServices = [];
    for (var category in _serviceCategories) {
      for (var service in category.subServices) {
        if (service.isSelected) {
          selectedServices.add(service);
        }
      }
    }
    return selectedServices;
  }

  void _showCenteredAlert(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleNextButtonPressed() {
    List<SubService> selectedServices = _getSelectedServices();

    if (selectedServices.isEmpty) {
      _showCenteredAlert('Please select at least one service to continue.');
    } else {
      Navigator.of(context).pushNamed('/date-time');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Scrollable Content Area (now full screen)
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Top padding to account for header height
                  const SizedBox(height: 140), // Adjust this value based on your header height

                  // Title with fade animation
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      "Mochi's Services",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Services List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: _serviceCategories.map((category) {
                        return _buildServiceCard(category);
                      }).toList(),
                    ),
                  ),

                  // Bottom padding for scroll area
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Progress Header (now overlays the content)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProgressHeader(
              title: 'grow Tokyo BKK',
              currentStep: 2,
              totalSteps: 3,
              stepLabels: ['Staff', 'Services', 'Date & Time'],
              onBackPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Footer Button (positioned at bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.grey[100], // Match scaffold background
              child: FooterButton(
                staffName: 'Mochi',
                onButtonPressed: _handleNextButtonPressed,
                buttonText: 'Next',
              ),

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(ServiceCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _toggleCategoryExpansion(_serviceCategories.indexOf(category)),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: ListTile(
                title: Text(
                  category.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                trailing: AnimatedRotation(
                  turns: category.isExpanded ? 0.5 : 0,
                  duration: category.isExpanded
                      ? const Duration(milliseconds: 0) // Smooth rotation when opening
                      : const Duration(milliseconds: 0), // Immediate rotation when closing
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: category.isExpanded
                ? const Duration(milliseconds: 0) // Smooth expand
                : const Duration(milliseconds: 0), // Immediate collapse
            curve: Curves.easeInOut,
            child: category.isExpanded
                ? _buildSubServices(category)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubServices(ServiceCategory category) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          if (category.subServices.isEmpty)
            AnimatedOpacity(
              opacity: category.isExpanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No services available',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...category.subServices.asMap().entries.map((entry) {
              int index = entry.key;
              SubService subService = entry.value;

              // Staggered animation delays only for expanding
              int expandDelay = index * 100;
              int collapseDelay = 0; // No delay for collapsing - all close at same time

              return TweenAnimationBuilder<double>(
                duration: Duration(
                  milliseconds: category.isExpanded
                      ? 300 + expandDelay  // Staggered expand with delay
                      : 0, // Immediate collapse
                ),
                tween: Tween<double>(
                  begin: category.isExpanded ? 0.0 : 1.0,
                  end: category.isExpanded ? 1.0 : 0.0,
                ),
                curve: category.isExpanded ? Curves.easeOut : Curves.linear,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: _buildSubServiceItem(category, subService),
                    ),
                  );
                },
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSubServiceItem(ServiceCategory category, SubService subService) {
    return InkWell(
      onTap: () => _toggleServiceSelection(category, subService),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image on the left
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                subService.imagePath,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.image, color: Colors.grey[400]),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    subService.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subService.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Square Checkbox on the right with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: subService.isSelected ? Colors.deepPurple : Colors.transparent,
                border: Border.all(
                  color: subService.isSelected ? Colors.deepPurple : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: AnimatedScale(
                scale: subService.isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.elasticOut,
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCategory {
  final String title;
  final List<SubService> subServices;
  bool isExpanded;

  ServiceCategory({
    required this.title,
    required this.subServices,
    this.isExpanded = false,
  });
}

class SubService {
  final String title;
  final String description;
  final String imagePath;
  bool isSelected;

  SubService({
    required this.title,
    required this.description,
    required this.imagePath,
    this.isSelected = false,
  });
}
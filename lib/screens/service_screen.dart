import 'package:flutter/material.dart';
import '../widgets/progress_header.dart';
import '../widgets/footer_button.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<ServiceCategory> _serviceCategories = [
    ServiceCategory(
      title: 'CUT INC SHAMPOO and BLOW DRY',
      subServices: [
        SubService(
          title: 'Cut (For Men)',
          description: 'Professional haircut for men',
          imagePath: 'assets/images/men_haircut.jpg',
          prices: [
            // Removed the specific price as requested
          ],
        ),
        SubService(
          title: 'Cut (For Lady)',
          description: 'Elegant haircut for women',
          imagePath: 'assets/images/lady_haircut.jpg',
          prices: [
            'Cambodian Hairstylist \$18',
          ],
        ),
        SubService(
          title: 'Cut (For Kids under 10 years)',
          description: 'Fun and safe haircuts for kids',
          imagePath: 'assets/images/kids_haircut.jpg',
          prices: [
            'Cambodian Hairstylist \$11',
          ],
        ),
      ],
    ),
    ServiceCategory(
      title: 'SHAMPOO and BLOW DRY',
      subServices: [],
    ),
    ServiceCategory(
      title: 'COLOR',
      subServices: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation when the page loads
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final String staffName = ModalRoute.of(context)?.settings.arguments as String? ?? 'Mochi';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
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
                      margin: const EdgeInsets.only(top: 25),
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "$staffName's Services",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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
                  leftText: _getSelectedServices().isEmpty
                      ? staffName
                      : '${_getSelectedServices().length} service(s) selected',
                  onNextPressed: () {
                    if (_getSelectedServices().isNotEmpty) {
                      // Navigation logic with selected services
                      print('Selected services: ${_getSelectedServices().map((s) => s.title).join(', ')}');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServiceCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          ListTile(
            title: Text(
              category.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            trailing: Icon(
              category.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey[600],
            ),
            onTap: () => _toggleCategoryExpansion(_serviceCategories.indexOf(category)),
          ),
          if (category.isExpanded)
            _buildSubServices(category),
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No services available',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...category.subServices.map((subService) {
              return _buildSubServiceItem(category, subService);
            }),
        ],
      ),
    );
  }

  Widget _buildSubServiceItem(ServiceCategory category, SubService subService) {
    return InkWell(
      onTap: () => _toggleServiceSelection(category, subService),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image on the left
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                subService.imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, color: Colors.grey[400]),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subService.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
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
                  if (subService.prices.isNotEmpty)
                    const SizedBox(height: 8),
                  ...subService.prices.map((price) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      price,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  )),
                ],
              ),
            ),
            // Checkbox on the right
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: subService.isSelected ? Colors.deepPurple : Colors.transparent,
                border: Border.all(
                  color: subService.isSelected ? Colors.deepPurple : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: subService.isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
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
  final List<String> prices;
  bool isSelected;

  SubService({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.prices,
    this.isSelected = false,
  });
}
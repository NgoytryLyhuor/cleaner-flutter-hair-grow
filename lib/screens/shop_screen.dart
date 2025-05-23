import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final String _currentPage = 'Shop';
  
  // Sample shop items
  final List<Map<String, dynamic>> _shopItems = [
    {
      'id': '1',
      'name': 'Professional Shampoo',
      'price': 25.99,
      'image': 'assets/images/product1.png',
      'description': 'Professional hair care shampoo for all hair types',
    },
    {
      'id': '2',
      'name': 'Hair Conditioner',
      'price': 22.50,
      'image': 'assets/images/product2.png',
      'description': 'Deep conditioning treatment for damaged hair',
    },
    {
      'id': '3',
      'name': 'Styling Gel',
      'price': 18.75,
      'image': 'assets/images/product3.png',
      'description': 'Strong hold styling gel for perfect hairstyles',
    },
    {
      'id': '4',
      'name': 'Hair Serum',
      'price': 32.00,
      'image': 'assets/images/product4.png',
      'description': 'Smoothing serum for frizz-free, shiny hair',
    },
  ];

  void _navigateToPage(String pageName) {
    switch (pageName) {
      case 'Home':
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 'My Booking':
        Navigator.of(context).pushReplacementNamed('/my-booking');
        break;
      case 'Shop':
        // Already on shop
        break;
      case 'User':
        Navigator.of(context).pushReplacementNamed('/user');
        break;
    }
  }

  void _viewProductDetails(String productId) {
    // Navigate to product details
    // This would be implemented in a real app
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing product $productId')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // Navigate to cart
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _shopItems.length,
                itemBuilder: (context, index) {
                  final item = _shopItems[index];
                  return _buildProductCard(item);
                },
              ),
            ),
            
            // Bottom Navigation
            BottomNavigation(
              currentPage: _currentPage,
              onPageChanged: _navigateToPage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => _viewProductDetails(product['id']),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: AssetImage(product['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product['price'].toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add to cart functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product['name']} added to cart')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        minimumSize: const Size(0, 30),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

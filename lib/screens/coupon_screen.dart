import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  final TextEditingController _couponController = TextEditingController();
  bool _isApplying = false;
  
  // Sample coupons data
  final List<Map<String, dynamic>> _coupons = [
    {
      'id': '1',
      'code': 'WELCOME25',
      'discount': '25% OFF',
      'description': 'Get 25% off on your first booking',
      'expiry': 'Jun 30, 2025',
      'isUsed': false,
    },
    {
      'id': '2',
      'code': 'HAIRCUT10',
      'discount': '10% OFF',
      'description': 'Get 10% off on all haircut services',
      'expiry': 'Jul 15, 2025',
      'isUsed': false,
    },
    {
      'id': '3',
      'code': 'SUMMER2025',
      'discount': '15% OFF',
      'description': 'Summer special discount on all services',
      'expiry': 'Aug 31, 2025',
      'isUsed': false,
    },
    {
      'id': '4',
      'code': 'FREESTYLE',
      'discount': 'FREE',
      'description': 'Free styling with any haircut service',
      'expiry': 'May 25, 2025',
      'isUsed': true,
    },
  ];

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    if (_couponController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a coupon code'),
        ),
      );
      return;
    }

    setState(() {
      _isApplying = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isApplying = false;
      });

      // Check if coupon exists
      final couponCode = _couponController.text.toUpperCase();
      final existingCoupon = _coupons.any((coupon) => coupon['code'] == couponCode);

      if (existingCoupon) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coupon already exists in your account'),
          ),
        );
      } else {
        // Add new coupon
        setState(() {
          _coupons.insert(0, {
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'code': couponCode,
            'discount': '20% OFF',
            'description': 'New coupon added',
            'expiry': 'Jun 30, 2025',
            'isUsed': false,
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coupon applied successfully'),
          ),
        );

        _couponController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Coupons'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Apply coupon section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apply Coupon',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          decoration: const InputDecoration(
                            hintText: 'Enter coupon code',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          textCapitalization: TextCapitalization.characters,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _isApplying ? null : _applyCoupon,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        child: _isApplying
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Coupons list
            Expanded(
              child: _coupons.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _coupons.length,
                      itemBuilder: (context, index) {
                        final coupon = _coupons[index];
                        final bool isUsed = coupon['isUsed'] as bool;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isUsed ? Colors.grey.shade100 : Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isUsed ? Colors.grey : Colors.green,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        coupon['discount'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (isUsed)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: const Text(
                                          'USED',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  coupon['code'],
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isUsed ? Colors.grey : null,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  coupon['description'],
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isUsed ? Colors.grey : null,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Valid until: ${coupon['expiry']}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: isUsed ? Colors.grey : Colors.grey.shade700,
                                      ),
                                    ),
                                    if (!isUsed)
                                      OutlinedButton(
                                        onPressed: () {
                                          // Copy coupon code to clipboard
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${coupon['code']} copied to clipboard'),
                                            ),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: const Text('Copy Code'),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Coupons Available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Apply a coupon code to get discounts',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

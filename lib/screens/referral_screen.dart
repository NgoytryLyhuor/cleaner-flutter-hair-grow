import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final String _referralCode = 'JOHN2025';
  
  // Sample referral history
  final List<Map<String, dynamic>> _referrals = [
    {
      'id': '1',
      'name': 'Jane Smith',
      'date': 'May 15, 2025',
      'points': 100,
      'status': 'completed',
    },
    {
      'id': '2',
      'name': 'Mike Johnson',
      'date': 'May 10, 2025',
      'points': 100,
      'status': 'completed',
    },
    {
      'id': '3',
      'name': 'Sarah Williams',
      'date': 'May 5, 2025',
      'points': 0,
      'status': 'pending',
    },
  ];

  void _shareReferralCode() {
    // In a real app, this would use a share plugin
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral code copied to clipboard'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Refer a Friend'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Referral info section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      color: Colors.blue,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Refer Friends & Earn Points',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Invite your friends to join Hair Salon. You\'ll get 100 points for each friend who completes their first booking.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Your Referral Code',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _referralCode,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _shareReferralCode,
                        icon: const Icon(Icons.share),
                        label: const Text('Share Code'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // How it works section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How It Works',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStepItem(
                      number: '1',
                      title: 'Share Your Code',
                      description: 'Share your unique referral code with friends',
                    ),
                    const SizedBox(height: 16),
                    _buildStepItem(
                      number: '2',
                      title: 'Friend Signs Up',
                      description: 'Your friend creates an account using your code',
                    ),
                    const SizedBox(height: 16),
                    _buildStepItem(
                      number: '3',
                      title: 'Friend Books Service',
                      description: 'Your friend completes their first booking',
                    ),
                    const SizedBox(height: 16),
                    _buildStepItem(
                      number: '4',
                      title: 'Earn Points',
                      description: 'You receive 100 points for each successful referral',
                    ),
                  ],
                ),
              ),
              
              // Referral history
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Referral History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _referrals.isEmpty
                        ? _buildEmptyReferrals()
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _referrals.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final referral = _referrals[index];
                              final bool isCompleted = referral['status'] == 'completed';
                              
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: isCompleted ? Colors.green.shade100 : Colors.orange.shade100,
                                  child: Icon(
                                    isCompleted ? Icons.check : Icons.hourglass_empty,
                                    color: isCompleted ? Colors.green : Colors.orange,
                                  ),
                                ),
                                title: Text(referral['name']),
                                subtitle: Text(referral['date']),
                                trailing: Text(
                                  isCompleted ? '+${referral['points']} pts' : 'Pending',
                                  style: TextStyle(
                                    color: isCompleted ? Colors.green : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyReferrals() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            const Icon(
              Icons.people_outline,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No referrals yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your code to start earning points',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

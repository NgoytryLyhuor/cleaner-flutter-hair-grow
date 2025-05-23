import 'package:flutter/material.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({Key? key}) : super(key: key);

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Sample countries data
  final List<Map<String, dynamic>> _countries = [
    {'name': 'Afghanistan', 'code': 'AF', 'flag': '🇦🇫', 'dialCode': '+93'},
    {'name': 'Albania', 'code': 'AL', 'flag': '🇦🇱', 'dialCode': '+355'},
    {'name': 'Algeria', 'code': 'DZ', 'flag': '🇩🇿', 'dialCode': '+213'},
    {'name': 'Andorra', 'code': 'AD', 'flag': '🇦🇩', 'dialCode': '+376'},
    {'name': 'Angola', 'code': 'AO', 'flag': '🇦🇴', 'dialCode': '+244'},
    {'name': 'Argentina', 'code': 'AR', 'flag': '🇦🇷', 'dialCode': '+54'},
    {'name': 'Australia', 'code': 'AU', 'flag': '🇦🇺', 'dialCode': '+61'},
    {'name': 'Austria', 'code': 'AT', 'flag': '🇦🇹', 'dialCode': '+43'},
    {'name': 'Belgium', 'code': 'BE', 'flag': '🇧🇪', 'dialCode': '+32'},
    {'name': 'Brazil', 'code': 'BR', 'flag': '🇧🇷', 'dialCode': '+55'},
    {'name': 'Cambodia', 'code': 'KH', 'flag': '🇰🇭', 'dialCode': '+855'},
    {'name': 'Canada', 'code': 'CA', 'flag': '🇨🇦', 'dialCode': '+1'},
    {'name': 'China', 'code': 'CN', 'flag': '🇨🇳', 'dialCode': '+86'},
    {'name': 'France', 'code': 'FR', 'flag': '🇫🇷', 'dialCode': '+33'},
    {'name': 'Germany', 'code': 'DE', 'flag': '🇩🇪', 'dialCode': '+49'},
    {'name': 'India', 'code': 'IN', 'flag': '🇮🇳', 'dialCode': '+91'},
    {'name': 'Indonesia', 'code': 'ID', 'flag': '🇮🇩', 'dialCode': '+62'},
    {'name': 'Italy', 'code': 'IT', 'flag': '🇮🇹', 'dialCode': '+39'},
    {'name': 'Japan', 'code': 'JP', 'flag': '🇯🇵', 'dialCode': '+81'},
    {'name': 'Malaysia', 'code': 'MY', 'flag': '🇲🇾', 'dialCode': '+60'},
    {'name': 'Mexico', 'code': 'MX', 'flag': '🇲🇽', 'dialCode': '+52'},
    {'name': 'Netherlands', 'code': 'NL', 'flag': '🇳🇱', 'dialCode': '+31'},
    {'name': 'New Zealand', 'code': 'NZ', 'flag': '🇳🇿', 'dialCode': '+64'},
    {'name': 'Philippines', 'code': 'PH', 'flag': '🇵🇭', 'dialCode': '+63'},
    {'name': 'Russia', 'code': 'RU', 'flag': '🇷🇺', 'dialCode': '+7'},
    {'name': 'Singapore', 'code': 'SG', 'flag': '🇸🇬', 'dialCode': '+65'},
    {'name': 'South Korea', 'code': 'KR', 'flag': '🇰🇷', 'dialCode': '+82'},
    {'name': 'Spain', 'code': 'ES', 'flag': '🇪🇸', 'dialCode': '+34'},
    {'name': 'Sweden', 'code': 'SE', 'flag': '🇸🇪', 'dialCode': '+46'},
    {'name': 'Switzerland', 'code': 'CH', 'flag': '🇨🇭', 'dialCode': '+41'},
    {'name': 'Thailand', 'code': 'TH', 'flag': '🇹🇭', 'dialCode': '+66'},
    {'name': 'United Kingdom', 'code': 'GB', 'flag': '🇬🇧', 'dialCode': '+44'},
    {'name': 'United States', 'code': 'US', 'flag': '🇺🇸', 'dialCode': '+1'},
    {'name': 'Vietnam', 'code': 'VN', 'flag': '🇻🇳', 'dialCode': '+84'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Map<String, dynamic>> get _filteredCountries {
    if (_searchQuery.isEmpty) {
      return _countries;
    }
    
    return _countries.where((country) {
      return country['name'].toLowerCase().contains(_searchQuery) ||
             country['code'].toLowerCase().contains(_searchQuery) ||
             country['dialCode'].toLowerCase().contains(_searchQuery);
    }).toList();
  }

  void _selectCountry(Map<String, dynamic> country) {
    Navigator.of(context).pop(country);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Country'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search country',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            
            // Countries list
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  
                  return ListTile(
                    leading: Text(
                      country['flag'],
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(country['name']),
                    subtitle: Text(country['dialCode']),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _selectCountry(country),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

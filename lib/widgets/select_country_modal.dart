import 'package:flutter/material.dart';

class SelectCountryModal extends StatefulWidget {
  final List<Map<String, dynamic>> countries;
  final Function(Map<String, dynamic>) onSelect;

  const SelectCountryModal({
    Key? key,
    required this.countries,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<SelectCountryModal> createState() => _SelectCountryModalState();
  
  // Show the country selection modal
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required List<Map<String, dynamic>> countries,
  }) async {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SelectCountryModal(
        countries: countries,
        onSelect: (country) => Navigator.of(context).pop(country),
      ),
    );
  }
}

class _SelectCountryModalState extends State<SelectCountryModal> {
  String _searchQuery = '';
  late List<Map<String, dynamic>> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
  }

  void _filterCountries(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCountries = widget.countries.where((country) {
        return country['name'].toString().toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Country',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: _filterCountries,
            decoration: InputDecoration(
              hintText: 'Search country',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                return ListTile(
                  leading: Text(
                    country['flag'] ?? '🏳️',
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(country['name']),
                  subtitle: Text(country['code'] ?? ''),
                  onTap: () => widget.onSelect(country),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

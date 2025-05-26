import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://demo-cms-hair-grow.camboinfo.com/api';

  // Singleton pattern for reusability
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Generic GET request method
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw ApiException('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // Generic POST request method
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw ApiException('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // Specific method for branch list
  Future<List<Map<String, dynamic>>> getBranchList() async {
    try {
      final response = await get('/branch-list');

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> branches = response['data'];

        // Transform API data to your app format
        return branches.asMap().entries.map((entry) {
          int index = entry.key;
          dynamic branch = entry.value;

          return {
            'id': branch['id'].toString(),
            'name': branch['name'] ?? '',
            'image': branch['branch_image'] ?? '',
            'isSelected': index == 0, // First branch is selected by default
          };
        }).toList();
      } else {
        throw ApiException('Invalid response format');
      }
    } catch (e) {
      throw ApiException('Failed to load branches: $e');
    }
  }

  // Specific method for staff list by branch_id
  Future<List<Map<String, dynamic>>> getStaffList(String branchId) async {
    try {
      final response = await get('/employee-list?branch_id=$branchId');

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> staffList = response['data'];

        // Transform API data to your app format
        List<Map<String, dynamic>> transformedStaff = staffList.map((staff) {
          return {
            'id': staff['id'].toString(),
            'name': staff['first_name'] ?? '',
            'description': staff['description'] ?? '',
            'image': staff['profile_image'] ?? '',
            'originalId': staff['id'], // Keep original ID for sorting
          };
        }).toList();

        // Sort staff: normal staff first, then special IDs in specific order
        final List<int> specialIds = [104, 105, 106, 290, 291];

        // Separate normal staff and special staff
        List<Map<String, dynamic>> normalStaff = [];
        List<Map<String, dynamic>> specialStaff = [];

        for (var staff in transformedStaff) {
          int staffId = staff['originalId'];
          if (specialIds.contains(staffId)) {
            specialStaff.add(staff);
          } else {
            normalStaff.add(staff);
          }
        }

        // Sort special staff according to the specified order
        specialStaff.sort((a, b) {
          int aIndex = specialIds.indexOf(a['originalId']);
          int bIndex = specialIds.indexOf(b['originalId']);
          return aIndex.compareTo(bIndex);
        });

        // Combine normal staff (first) + special staff (bottom, ordered)
        List<Map<String, dynamic>> sortedStaff = [...normalStaff, ...specialStaff];

        // Remove the originalId field as it's not needed in UI
        return sortedStaff.map((staff) {
          staff.remove('originalId');
          return staff;
        }).toList();
      } else {
        throw ApiException('Invalid response format');
      }
    } catch (e) {
      throw ApiException('Failed to load staff: $e');
    }
  }
}

// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
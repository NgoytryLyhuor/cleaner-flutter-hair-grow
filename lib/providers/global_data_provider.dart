import 'package:flutter/material.dart';

class GlobalDataProvider extends ChangeNotifier {
  // User data
  Map<String, dynamic> _userData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+1 234 567 8901',
    'profileImage': null,
  };

  // Getter for user data
  Map<String, dynamic> get userData => _userData;

  // Method to update user data
  void updateUserData(Map<String, dynamic> newData) {
    _userData.addAll(newData);
    notifyListeners();
  }

  // Add other global state and methods as needed
  // For example: booking data, selected services, etc.
}

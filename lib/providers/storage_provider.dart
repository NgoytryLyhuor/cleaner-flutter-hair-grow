import 'package:flutter/material.dart';

class StorageProvider extends ChangeNotifier {
  // Storage for user preferences and data
  Map<String, dynamic> _storage = {};

  // Getter for storage
  Map<String, dynamic> get storage => _storage;

  // Set a value in storage
  void setValue(String key, dynamic value) {
    _storage[key] = value;
    notifyListeners();
  }

  // Get a value from storage
  dynamic getValue(String key) {
    return _storage[key];
  }

  // Remove a value from storage
  void removeValue(String key) {
    _storage.remove(key);
    notifyListeners();
  }

  // Clear all storage
  void clearStorage() {
    _storage.clear();
    notifyListeners();
  }
}

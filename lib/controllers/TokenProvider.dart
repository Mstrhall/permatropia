import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider extends ChangeNotifier {
  String? _token;
  String get token => _token ?? '';

  // Load the token from SharedPreferences when the app starts
  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  // Save the token to SharedPreferences
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token = token;
    notifyListeners();
  }

  // Remove the token from SharedPreferences
  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
    notifyListeners();
  }
}

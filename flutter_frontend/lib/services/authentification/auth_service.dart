import 'package:flutter_frontend/constants/api_endpoints.dart';
import 'package:flutter_frontend/models/user_credential.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class AuthService extends ChangeNotifier {
  UserCredential? _userCredential;

  UserCredential? get userCredential => _userCredential;

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userCredentialString = prefs.getString('userCredential');
    if (userCredentialString != null) {
      final userCredentialJson = jsonDecode(userCredentialString);
      _userCredential = UserCredential.fromJson(userCredentialJson);
    }
    notifyListeners();
  }

  Future<UserCredential?> signInWithEmailandPassword(
      String email, String password) async {
    final response = await http.post(
      Uri.parse(loginEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        final userCredential = UserCredential.fromJson(responseBody['user']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'userCredential', jsonEncode(userCredential.toJson()));
        _userCredential = userCredential;
        notifyListeners();
        return userCredential;
      } else {
        throw Exception('Invalid credentials!');
      }
    } else {
      throw Exception('Failed to communicate with server!');
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userCredential');
    _userCredential = null;
    notifyListeners();
  }

  Future<void> signUpWithEmailandPassword(
      String email, password, username, image) async {}
}

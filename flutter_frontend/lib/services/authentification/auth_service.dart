import 'package:flutter_frontend/constants/api_endpoints.dart';
import 'package:flutter_frontend/models/user_credential.dart';
import 'package:flutter_frontend/utils/shared_prefs_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class AuthService extends ChangeNotifier {
  UserCredential? _userCredential;

  UserCredential? get userCredential => _userCredential;

  Future<void> getUser() async {
    _userCredential = await SharedPrefsHelper.getUserCredential();
    notifyListeners();
  }

  Future<UserCredential?> signInWithEmailandPassword(
      String email, String password) async {
    final response = await http.post(
      Uri.parse(signInEndpoint),
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
        _userCredential =
            await SharedPrefsHelper.setUserCredential(responseBody['user']);
        notifyListeners();

        return userCredential;
      } else {
        throw Exception('Invalid credentials!');
      }
    } else {
      throw Exception('Failed to communicate with server!');
    }
  }

  Future<UserCredential?> signUpWithEmailandPassword(
      String email, String password, String username, File? image) async {
    String? base64Image;
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    final response = await http.post(
      Uri.parse(signUpEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'username': username,
        'image': base64Image ?? '',
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        _userCredential =
            await SharedPrefsHelper.setUserCredential(responseBody['user']);

        notifyListeners();
        return userCredential;
      } else {
        throw Exception('Failed to sign up: ${responseBody['error']}');
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
}

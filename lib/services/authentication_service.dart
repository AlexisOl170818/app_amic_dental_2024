import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService extends ChangeNotifier {
  signin(String email, int badgeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isAuthUser", true);
  }

  Future<bool> verifyAuthUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isAuthUser") ?? false;
  }

  signout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

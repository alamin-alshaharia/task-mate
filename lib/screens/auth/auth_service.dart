import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../utils/logger.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();

  Future<void> googleSignIn(BuildContext context) async {
    try {
      // TODO: Update Google Sign-In to work with latest version 7.2.0
      // For now, disabled due to breaking changes in API
      AppLogger.w('Google Sign-In temporarily disabled - needs API update');
      if (context.mounted) {
        final snackBar =
            SnackBar(content: Text('Google Sign-In temporarily unavailable'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      AppLogger.e('Google Sign-In error: $e');
      if (context.mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    try {
      await _auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {
      if (context.mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void storeTokenAndData(UserCredential userCredential) async {
    AppLogger.d("Storing token and data");
    await storage.write(
        key: "token", value: userCredential.credential?.token.toString());
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  }

  Future<String> getToken() async {
    return storage.read(key: "token").toString();
  }
}

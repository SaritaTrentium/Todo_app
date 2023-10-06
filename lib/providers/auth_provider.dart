import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier{

  bool _isLoggedIn = false;
  bool get isLoggedIn => _userId != null;

  String? _userId;
  String? get userId => _userId;

  Future<void> signUpUser(String name, String email, String password, BuildContext context) async {
    try {
      String getUserId = await AuthServices.signUpUser(name, email, password, context);
    // print('Get userID AuthProvider : $getUserId');
        _userId = getUserId;
        _isLoggedIn = true;
        notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> signInUser(String email, String password, BuildContext context)async {
    try{
      await AuthServices.signInUser(email, password, context);
      _isLoggedIn = true;
      notifyListeners();
    }catch(e){
      print(e);
    }
  }

  Future<void> signOut()async {
   try{
     await AuthServices.signOut();
     _isLoggedIn = false;
     notifyListeners();
   }catch(e){
     print('Sign out failed: $e');
   }
  }

 Future<User?> checkUserExists(String email, String password) async {
    try{
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email,
          password: password);
      final user = userCredential.user;
      if (user != null) {
        // User exists, sign them out (since we only wanted to check existence)
        await FirebaseAuth.instance.signOut();
      }
      return user;
    }catch(error){
      // User does not exist or other login error occurred
      return null;
    }
 }

  bool isUserSignedIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
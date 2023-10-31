
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier{

  bool _isLoggedIn = false;
  bool get isLoggedIn => _userId != null;

  String? _userId;
  String? get userId => _userId;

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  GoogleSignInAccount? get googleUser => null;

  Future<void> signUpUser(String name, String email, String password, BuildContext context) async {
    try {
      await AuthServices.signUpUser(name, email, password, context);
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

  // Future<User?> signUpWithGoogle()async {
  //   try{
  //     await AuthServices.signUpWithGoogle();
  //     _isLoggedIn = true;
  //     _user = googleUser;
  //     notifyListeners();
  //   }catch(e){
  //    print(e.toString());
  //   }
  // }

  Future<void> signOut()async {
   try{
     await AuthServices.signOut();
     _isLoggedIn = false;
     notifyListeners();
   }catch(e){
     print('Sign out failed: $e');
   }
  }

  Future<void> signUpWithPhoneNumber(String phoneNumber, BuildContext context) async{
    try{
      await AuthServices.signUpWithPhoneNumber(phoneNumber, context);
      _isLoggedIn = true;
      notifyListeners();
    }catch(e){
      print(e.toString());
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

    if(user != null){
      return true;
    }else {
      return false;
    }
  }
}
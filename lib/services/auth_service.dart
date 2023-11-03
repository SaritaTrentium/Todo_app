import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/models/user_model.dart';

class AuthServices {

  static Future signUpWithGoogle(BuildContext context) async{
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      // You can use FirebaseAuth.instance.currentUser to check if the user is signed in.
      if (FirebaseAuth.instance.currentUser != null) {
        // Navigate to the home screen
        Navigator.of(context).pushNamed('/home');
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }

  static signUpWithPhoneNumber(String phoneNumber,BuildContext context)async {
    try{
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
            await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException e){
            print('Verification failed: ${e.message}');
          },
          codeSent: (String verificationId, int? resendToken){

          },
          codeAutoRetrievalTimeout: (String verificationId){}
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration Successfully with Google")));
    }on FirebaseAuthException catch(e){
      SnackBar(content: Text(e.toString()));
    }
  }

  static Future signUpUser(String name, String email, String password,
      BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);

      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final String getUserId = firebaseUser.uid;
        print('User Id during SignUp: $getUserId');
        Users(userId: getUserId, email: email, password: password);

        await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
        await FirebaseAuth.instance.currentUser!.updateEmail(email);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration Successfully")));
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
       // return getUserId;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User registration failed")),
        );
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email Provided already Exists.')));
      }else if(e.code == 'The email address is badly formatted'){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email Provided already Exists.')));

      }
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }

  static Future signInUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You are Logged in")));

      final user = FirebaseAuth.instance.currentUser;
      if(user != null){
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You are not LogIn.")));
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found with this Email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password did not match')));
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Login')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }

  static Future signOut() async {
    final auth = FirebaseAuth.instance;
    try {
      final user = auth.currentUser;
      if(user != null){
        await FirebaseAuth.instance.signOut();
      }else{
        print('Sign out failed');
      }
    } catch (e) {
      print('Sign out failed: $e');
    }
  }
}

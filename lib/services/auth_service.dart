import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/user_model.dart';
import '../pages/todo_list_page.dart';

class AuthServices {

  static signUpUser(String name, String email, String password,
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TodoListPage(),
          ),
        );
        return getUserId;
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
      }
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }

  static signInUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You are Logged in")));

      final user = FirebaseAuth.instance.currentUser;
      if(user != null){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TodoListPage()));
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

  static signOut() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
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

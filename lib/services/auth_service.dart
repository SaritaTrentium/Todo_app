import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/models/user_model.dart';
import '../models/todo_model.dart';
import '../pages/todo_list_page.dart';
import 'firebase_function.dart';

class AuthServices {

  static signUpUser(String name, String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);

      final firebaseUser = FirebaseAuth.instance.currentUser;
      if(firebaseUser != null){
          final String getUserId = firebaseUser.uid;
          print('User Id: $getUserId');
          final user = Users(userId: getUserId, email: email, password: password);

          await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
          await FirebaseAuth.instance.currentUser!.updateEmail(email);
          await FirestoreServices.saveUser(name, email,password, userCredential.user!.uid);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Successfully")));

        return getUserId;
      } else {
        return null;
      }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email Provided already Exists.')));
      }
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static  signInUser(String email, String password, BuildContext context)async {
    final todoBox = Hive.box<Todo>('todos');
    final todos = todoBox.values.toList();
    try{
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        final userId = userCredential.user!.uid;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You are Logged in")));

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TodoListPage(todos: todos)));

    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found with this Email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password did not match')));
      }else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Login')));
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static signOut()async{
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Sign out failed: $e');
    }
  }
}
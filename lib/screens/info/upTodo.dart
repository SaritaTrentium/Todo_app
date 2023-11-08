import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/common/resources/string_resources.dart';
class UpTodo extends StatefulWidget {
  const UpTodo({super.key});

  @override
  State<UpTodo> createState() => _UpTodoState();
}

class _UpTodoState extends State<UpTodo> {

  void timer(){
      Timer(const Duration(seconds: 2),(){
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if(user != null){
            if(mounted){
              Navigator.of(context).pushReplacementNamed('/dashboard');
            }
          }else{
            if(mounted){
              Navigator.of(context).pushReplacementNamed('/slider');
            }
          }
        });
      });
    }

    @override
    void initState() {
    super.initState();
    timer();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 130.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/info/todo.png',height: 400,width: 400,),
                Text(StringResources.getTitle,style: TextStyle(
                  color: brightness == Brightness.dark
                    ? Colors.white // Text color for dark mode
                    : Colors.deepPurple, // Text color for light mode
                  fontSize: 40,
                  fontWeight: FontWeight.w500,)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

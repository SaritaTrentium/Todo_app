import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
              Navigator.of(context).pushReplacementNamed('/home');
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
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/info/todo.png',height: 400,width: 400,),
            Text('Todo App',style: TextStyle(color: Colors.purple.shade400,fontSize:40,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}

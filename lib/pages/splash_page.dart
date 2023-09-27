import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/signup_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    if(mounted){
      _timer =Timer(Duration(seconds: 2),
              () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpPage())));
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: Text('Welcome \n      To \nTodoApp',style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.purple),)),
      ),
    );
  }
}

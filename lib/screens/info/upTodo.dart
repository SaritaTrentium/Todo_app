import 'package:flutter/material.dart';
class UpTodo extends StatefulWidget {
  const UpTodo({super.key});

  @override
  State<UpTodo> createState() => _UpTodoState();
}

class _UpTodoState extends State<UpTodo> {
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      Navigator.of(context).pushReplacementNamed('/slider');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/info/todo.png',height: 400,width: 400,),
            Text('Todo App',style: TextStyle(color: Colors.purple.shade400,fontSize:40,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}

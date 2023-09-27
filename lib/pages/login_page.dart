import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/signup_page.dart';
import 'package:todo_app/pages/todo_list_page.dart';
import '../models/todo_model.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoBox = Hive.box<Todo>('todos');
    final todos = todoBox.values.toList();
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text("Welcome To Login",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:16,left: 32, right: 32),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Enter Your Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Email can not be empty.";
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:16 ,left: 32, right: 32),
              child: TextFormField(
                controller: pwdController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter Your Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if(value!.isEmpty){
                    return "Password can not be empty.";
                  } else if(value.length <6){
                    return "Password length should be at least 6.";
                  }
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(onPressed: () async {
              if(_formKey.currentState!.validate()){
                  final email = emailController.text.trim();
                  final password = pwdController.text.trim();
                  authProvider.signInUser(email, password, context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TodoListPage(todos: todos)));
              }
            //
            }, child: const Text('Login')),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Don't have an account?"),
                TextButton(onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>SignUpPage()));
                } , child: const Text('SignUp')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

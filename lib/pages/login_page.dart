import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/signup_page.dart';
import 'package:todo_app/pages/todo_list_page.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import '../models/todo_model.dart';
import '../providers/auth_provider.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';
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
  void initState() {
    super.initState();
    getUserLoggedIn();
  }

  Future<void> getUserLoggedIn() async {
    bool isLoggedIn = await getLoginState();

    if (isLoggedIn) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Open a Hive box
        final todoBox = await Hive.openBox<Todo>('todos_${user.email}');
        try {
          final todoListProvider = Provider.of<TodoListProvider>(context, listen: false);
          final todos = await todoListProvider.fetchUserTodos(user.email);
          todoBox.addAll(todos);
          setState(() {
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => TodoListPage()));
          });
        } catch (e) {
          print('Error while fetching todos: $e');
          // LoginPage();
        }
      } else {
        LoginPage();
      }
    } else {
      LoginPage();
    }
  }
    @override
    Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email can not be empty.";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
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
                    if (value!.isEmpty) {
                      return "Password can not be empty.";
                    } else if (value.length < 6) {
                      return "Password length should be at least 6.";
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final email = emailController.text.trim();
                  final password = pwdController.text.trim();
                  authProvider.signInUser(email, password, context);
                  try {
                    // Check if the user already exists
                    final user = await authProvider.checkUserExists(email, password);

                    if (user != null) {
                      // User exists, log them in
                      await authProvider.signInUser(email, password, context);
                      saveLoginState(true);
                    } else {
                      // User doesn't exist, show an error message
                      // You can display a message here indicating that the user needs to sign up first
                      // You can also navigate to the signup page if needed
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                    }
                  } catch (error) {
                    // Handle login error
                  }
                }

              }, child: const Text('Login')),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  }, child: const Text('SignUp')),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

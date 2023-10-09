import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/login_page.dart';
import 'package:todo_app/pages/todo_list_page.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';
import '../models/todo_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.isLoggedIn) {
      return LoginPage();
    }
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('SignUp',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
                child: TextFormField(
                  key: ValueKey('fullname'),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Full Name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                child: TextFormField(
                  controller: emailController,
                  key: ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email ID';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                child: TextFormField(
                  controller: pwdController,
                  key: ValueKey('password'),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password can not be empty.';
                    } else if (value.length < 6) {
                      return 'Password length should be at least 6.';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String name = nameController.text.trim();
                  String email = emailController.text.trim();
                  String password = pwdController.text.trim();
                  print('Sign Up With This Name :$name ,Email: $email and password: $password');

                   authProvider.signUpUser(name, email, password, context);
                    final user = FirebaseAuth.instance.currentUser;
                    try{
                      if(user != null){
                        saveLoginState(true);
                        final todoBox = await Hive.openBox<Todo>('todos_${user!.email}');
                        await todoBox.clear();
                      } else{
                        print("Again SignUp Properly");
                      }
                    }catch (error){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SignUp Process not working Properly.")));
                    }
                  }else {
                    // Handle the case where sign-up failed
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Sign-up failed. Please try again."),
                    ));
                  }
              }, child: const Text('Create an account')),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () async{
                        setState(() {
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => LoginPage()));
                          });
                        }, child: const Text('Login')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
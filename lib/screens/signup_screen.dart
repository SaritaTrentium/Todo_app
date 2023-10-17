import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/textfield.dart';
import 'package:todo_app/pages/login_page.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';
import '../common/button.dart';
import '../models/todo_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late AuthProvider _authProvider;
    _authProvider = Provider.of<AuthProvider>(context);
    if (_authProvider.isLoggedIn) {
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
                child: CustomTextField(
                  labelText: 'Enter your Name',
                  controller: _nameController,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Name can not be empty.';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                child: CustomTextField(
                  labelText: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                    if (value == null || value.isEmpty) {
                      return 'Email can not be empty.';
                    } else if(emailRegex.hasMatch(value)){
                      return 'Invalid email format';
                    }else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                child: CustomTextField(
                  labelText: 'Enter your password',
                  controller: _pwdController,
                  obscureText: true,
                  validator: (value){
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
              CustomElevatedButton(onPressed: () async {

                if (_formKey.currentState!.validate()) {
                  String name = _nameController.text.trim();
                  String email = _emailController.text.trim();
                  String password = _pwdController.text.trim();
                  print('Sign Up With This Name :$name ,Email: $email and password: $password');

                   _authProvider.signUpUser(name, email, password, context);
                    final user = FirebaseAuth.instance.currentUser;
                    try{
                      if(user != null){
                        saveLoginState(true);
                        final todoBox = await Hive.openBox<Todo>('todos_${user.email}');
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
              },text: 'Create an account'),
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
                            Navigator.of(context).pushNamed('/');
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
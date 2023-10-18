import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_button.dart';
import 'package:todo_app/common/custom_textfield.dart';
import 'package:todo_app/common/validator.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';
import '../models/todo_model.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
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
    bool isLoading = false;
    late AuthProvider _authProvider;
    _authProvider = Provider.of<AuthProvider>(context);
    if (_authProvider.isLoggedIn) {
      return LoginScreen();
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
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  validator:(value) => Validator.validateTitle(nameController.text),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                child: CustomTextField(
                  labelText: 'Enter your email',
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator:(value) => Validator.validateTitle(emailController.text),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                child: CustomTextField(
                  labelText: 'Enter your password',
                  controller: pwdController,
                  textInputAction: TextInputAction.done,
                  validator: (value) => Validator.validatePassword(pwdController.text),
                  obscureText: true,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              CustomElevatedButton(onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String name = nameController.text.trim();
                    String email = emailController.text.trim();
                    String password = pwdController.text.trim();
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
                  } else {
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
                      onPressed: isLoading
                      ? () {
                            CircularProgressIndicator();
                          }
                      : () {
                            Navigator.of(context).pushReplacementNamed('/login');
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
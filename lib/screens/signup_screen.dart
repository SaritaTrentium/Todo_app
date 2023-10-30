import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_button.dart';
import 'package:todo_app/common/custom_outlinebutton.dart';
import 'package:todo_app/common/custom_textformfield.dart';
import 'package:todo_app/common/resources/cudtom_divider.dart';
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
  Widget build(BuildContext context) {
    bool isLoading = false;
    late AuthProvider _authProvider;
    _authProvider = Provider.of<AuthProvider>(context);
    if (_authProvider.isLoggedIn) {
      return LoginScreen();
      }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('SignUp',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.deepPurple),),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    labelText: 'Enter your Name',
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    validator:(value) => Validator.validateTitle(nameController.text),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Enter your email',
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator:(value) => Validator.validateEmail(emailController.text),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Enter your password',
                    controller: pwdController,
                    textInputAction: TextInputAction.done,
                    validator: (value) => Validator.validatePassword(pwdController.text),
                    isPassword: true,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomElevatedButton(onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
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
                                  }finally {
                              setState(() {
                                isLoading = false; // Set loading back to false after the signup process is complete.
                              });
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Sign-up failed. Please try again."),
                            ));
                          }
                      }, text: 'Create an account',
                      ),
                    ),
                    const SizedBox(height: 30),
                  CustomDivider(),
                  const SizedBox(height: 30,),
                  CustomOutlineButton(
                      onPressed: () =>_authProvider.signUpWithGoogle(),
                       text: 'Register with Google', color: Colors.white, textColor: Colors.deepPurple,),
                  const SizedBox(height: 20,),
                  CustomOutlineButton(
                      text: 'Register with PhoneNumber', color: Colors.white, textColor: Colors.deepPurple,
                      onPressed: (){
                        Navigator.of(context).pushReplacementNamed('/otp');
                  }),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                          onPressed: () {
                                Navigator.of(context).pushReplacementNamed('/login');
                            }, child: const Text('Login',style: TextStyle(color: Colors.deepPurple),)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
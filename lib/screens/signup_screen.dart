import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_button.dart';
import 'package:todo_app/common/custom_loader.dart';
import 'package:todo_app/common/custom_outlinebutton.dart';
import 'package:todo_app/common/custom_textformfield.dart';
import 'package:todo_app/common/resources/custom_divider.dart';
import 'package:todo_app/common/resources/string_resources.dart';
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
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 128.0,left: 32.0, right: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(StringResources.getSignupTitle,
                      style: TextStyle(
                        color: brightness == Brightness.dark
                            ? Colors.white // Text color for dark mode
                            : Colors.deepPurple, // Text color for light mode
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      )),
                    const SizedBox(height: 30),
                    CustomTextFormField(
                      labelText: StringResources.getEnterName,
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      validator:(value) => Validator.validateTitle(nameController.text),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: StringResources.getEnterEmail,
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator:(value) => Validator.validateEmail(emailController.text),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      labelText: StringResources.getEnterPassword,
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
                              String name = nameController.text.trim();
                              String email = emailController.text.trim();
                              String password = pwdController.text.trim();
                              print('Sign Up With This Name :$name ,Email: $email and password: $password');

                             _authProvider.signUpUser(name, email, password, context);
                             setState(() {
                                isLoading = true;
                              });
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
                        }, text: StringResources.getCreateAccount,
                        ),
                      ),
                    if (isLoading) // Show the CircularProgressIndicator when isLoading is true.
                      CustomLoader(), // Custom loader
                      const SizedBox(height: 30),
                    CustomDivider(),
                    const SizedBox(height: 30,),
                    CustomOutlineButton(
                      onPressed: () =>_authProvider.signUpWithGoogle(context),
                      text: StringResources.getSignInGoogle, color: Colors.white, textColor: brightness == Brightness.dark
                        ? Colors.white
                        : Colors.deepPurple,fontSize: 25,),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(StringResources.getAlreadyAccount),
                        TextButton(
                            onPressed: () {
                                  Navigator.of(context).pushReplacementNamed('/login');
                              }, child: Text(StringResources.getLoginTitle,style: TextStyle(color: brightness == Brightness.dark
                            ? Colors.white // Text color for dark mode
                            : Colors.deepPurple, // Text color for light mode
                          fontWeight: FontWeight.w500,
                        ),
                         ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
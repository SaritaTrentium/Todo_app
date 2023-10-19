import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_button.dart';
import 'package:todo_app/common/custom_textfield.dart';
import 'package:todo_app/common/validator.dart';
import '../providers/auth_provider.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var logger;
  Validator validator = Validator();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  // @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final isUserLoggedInStatus = await getLoginState();
    try{
      if(isUserLoggedInStatus){
        final user = FirebaseAuth.instance.currentUser;
        if(user != null){
          print('Login with the current Email: ${user.email}');
          saveLoginState(true);
          Navigator.of(context).pushNamed('/todoList');
        }
      }else{
        print('SignUp First');
      }
    }catch (error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Go to the SignUp Page")));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    late AuthProvider _authProvider;
    _authProvider = Provider.of<AuthProvider>(context);
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
              child: CustomTextField(
                labelText: 'Enter your Email',
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
                obscureText: true,
                validator:(value) => Validator.validateTitle(pwdController.text),
                ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomElevatedButton(onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final email = emailController.text.trim();
                    final password = pwdController.text.trim();
                    try {
                      final user = await _authProvider.checkUserExists(
                          email, password);
                      if (user != null) {
                        await _authProvider.signInUser(email, password, context);
                        saveLoginState(true);
                        _authProvider.isUserSignedIn();
                      } else {
                        Navigator.of(context).pushNamed('/signUp');
                      }
                    } catch (error) {
                      print("User not Logged In First SignUp.");
                    }
                  }
                }, text: 'Login'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
                children: <Widget>[
                  Expanded(
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.grey,
                      )
                  ),
                  Text("OR"),
                  Expanded(
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.grey,
                      )
                  ),
                ]
            ),
            const SizedBox(
              height: 50,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SizedBox(
            //     width: double.infinity,
            //     height: 50,
            //     child: CustomElevatedButton(text: 'Login with Google', onPressed: (){}),
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SizedBox(
            //     width: double.infinity,
            //     height: 50,
            //     child: CustomElevatedButton(text: 'Login with Phone', onPressed: (){}),
            //   ),
            // ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Don't have an account?"),
                TextButton(onPressed: isLoading
                    ? () {CircularProgressIndicator();}
                    : () {
                  Navigator.of(context).pushReplacementNamed('/signUp');
                }, child: const Text('SignUp')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

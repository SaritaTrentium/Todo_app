import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_button.dart';
import 'package:todo_app/common/custom_outlinebutton.dart';
import 'package:todo_app/common/custom_textformfield.dart';
import 'package:todo_app/common/validator.dart';
import 'package:todo_app/providers/google_sign_in_provider.dart';
import '../common/resources/cudtom_divider.dart';
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

  void dispose(){
    super.dispose();
    emailController.clear();
    pwdController.clear();
  }

  Future<void> checkLoginStatus() async {
    final isUserLoggedInStatus = await getLoginState();
    try{
      if(isUserLoggedInStatus){
        final user = FirebaseAuth.instance.currentUser;
        if(user != null){
          print('Login with the current Email: ${user.email}');
          saveLoginState(true);
          Navigator.of(context).pushNamed('/home');
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
    late GoogleSignInProvider _googleSignInProvider;
    _googleSignInProvider = Provider.of<GoogleSignInProvider>(context);
    late AuthProvider _authProvider;
    _authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Login",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurple),),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextFormField(
                    labelText: 'Enter your email',
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    //autofillHints: [AutofillHints.email],
                    validator:(value) => Validator.validateEmail(emailController.text),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Not exist need to SignUp")));
                          }
                        } catch (error) {
                          print("User not Logged In First SignUp.");
                        }
                      }
                    }, text: 'Login'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomDivider(),
                  const SizedBox(height: 20,),
                  CustomOutlineButton(
                    onPressed: () =>_googleSignInProvider.googleLogin(),
                    text: 'Google', color: Colors.white, textColor: Colors.deepPurple,fontSize: 25,),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomOutlineButton(
                      text: 'PhoneNumber', color: Colors.white, textColor: Colors.deepPurple, fontSize: 25,
                      onPressed: (){
                        Navigator.of(context).pushReplacementNamed('/otp');
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/signUp');
                      }, child: const Text('SignUp',style: TextStyle(color: Colors.deepPurple),)),
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

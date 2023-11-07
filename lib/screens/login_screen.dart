import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_button.dart';
import 'package:todo_app/common/custom_outlinebutton.dart';
import 'package:todo_app/common/custom_textformfield.dart';
import 'package:todo_app/common/resources/string_resources.dart';
import 'package:todo_app/common/validator.dart';
import '../common/resources/custom_divider.dart';
import '../providers/auth_provider.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
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
    late AuthProvider _authProvider;
    _authProvider = Provider.of<AuthProvider>(context);
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 128.0,left: 32, right: 32),
              child: Column(
                children: [
                  Text(StringResources.getLoginTitle,
                    style: TextStyle(
                      color: brightness == Brightness.dark
                          ? Colors.white // Text color for dark mode
                          : Colors.deepPurple, // Text color for light mode
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    )),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomTextFormField(
                    labelText: StringResources.getEnterEmail,
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: CustomElevatedButton(onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final email = emailController.text.trim();
                            final password = pwdController.text.trim();
                            try {
                              setState(() {
                                isLoading = true;
                              });
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
                            }finally {
                              // Ensure to reset the loading state when the operation is complete
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                      }, text: StringResources.getLoginTitle,
                            textColor: Theme.of(context).brightness == Brightness.dark
                              ?  Colors.black
                              :  Colors.white,),
                        ),
                        Visibility(
                          visible: isLoading, // Control visibility based on loading state
                          child: CircularProgressIndicator(), // Circular progress indicator
                        ),
                    ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomDivider(),
                  const SizedBox(height: 50,),
                  CustomOutlineButton(
                    onPressed: () =>_authProvider.signUpWithGoogle(context),
                    text: StringResources.getSignInGoogle, color: Colors.white, textColor: brightness == Brightness.dark
                    ? Colors.white
                    : Colors.deepPurple,fontSize: 25,),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(StringResources.getHaveAccount),
                      TextButton(onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/signUp');
                      }, child: Text(StringResources.getSignupTitle,style: TextStyle(
                        color: brightness == Brightness.dark
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
    );
  }
}

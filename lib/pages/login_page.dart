import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              child: Image(image: AssetImage('assets/images/user.jpg')
              ),
              maxRadius: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top:32 ,left: 32, right: 32),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Enter Your Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
               validator: (value) {
                 if(value!.isEmpty){
                   return "User can not be empty.";
                 }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:16 ,left: 32, right: 32),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter Your Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Email can not be empty.";
                  } else if(value.contains('@')) {
                    return "Email should contains @.";
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:16 ,left: 32, right: 32),
              child: TextFormField(
                controller: pwdController,
                decoration: InputDecoration(
                  labelText: 'Enter Your Name',
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
              height: 30,
            ),
            ElevatedButton(onPressed: () { }, child: const Text('Login')),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Create An New Account'),
                TextButton(onPressed: () {} , child: const Text('SignUp')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

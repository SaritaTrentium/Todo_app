import 'package:flutter/material.dart';
import 'package:todo_app/common/custom_button.dart';
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 128.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Column(
             children: [ const Text('Welcome to TodoApp',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35),),
               const SizedBox(height: 20,),
               const Text('Please login to your account or create \n new account to continue',textAlign: TextAlign.center ,style: TextStyle(color: Colors.blueGrey, fontSize: 14),),],
           ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: CustomElevatedButton(text: 'LOGIN', onPressed: (){
                      Navigator.of(context).pushReplacementNamed('/login');
                    }),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: CustomElevatedButton(text: 'CREATE ACCOUNT', onPressed: (){
                      Navigator.of(context).pushReplacementNamed('/signUp');
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

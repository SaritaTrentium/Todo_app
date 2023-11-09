import 'package:flutter/material.dart';
import 'package:todo_app/common/custom_button.dart';
import 'package:todo_app/common/resources/string_resources.dart';
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 128.0, left: 16.0, right: 16.0, bottom: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Column(
             children: [
               Text(StringResources.getWelcomeTodo,style: TextStyle(
                 color: brightness == Brightness.dark
                 ? Colors.white: Colors.deepPurple,
                   fontWeight: FontWeight.bold,fontSize: 35),),
               const SizedBox(height: 20,),
               Text(StringResources.getWelcomeTodoSubTitle,textAlign: TextAlign.center ,style: TextStyle(
               color: brightness == Brightness.dark
               ? Colors.white: Colors.deepPurple.shade300,
                   fontSize: 16,
               ), ),],
           ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: CustomElevatedButton(text: StringResources.getLoginTitle, onPressed: (){
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
                    child: CustomElevatedButton(text: StringResources.getCreateAccount, onPressed: (){
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

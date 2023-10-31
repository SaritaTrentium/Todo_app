import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget{
  final String text;
  final Color color;
  final Color textColor;
  final Function onPressed;
//  final Widget? child;
  const CustomElevatedButton({super.key,required this.text, required this.onPressed, this.color = Colors.blue, this.textColor = Colors.white});

  Widget build(BuildContext context){
    return ElevatedButton(
        onPressed: () {
          onPressed();
        },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).brightness == Brightness.light
              ? Colors.deepPurpleAccent.shade200
              : Colors.black12,
        ),
      ),
        child: Text(text,style: TextStyle(color: textColor),),
    );
  }
}
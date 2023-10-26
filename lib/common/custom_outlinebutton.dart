import 'package:flutter/material.dart';
class CustomOutlineButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Function onPressed;
  const CustomOutlineButton({super.key, required this.onPressed, required this.text, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: OutlinedButton(
          child: Text(text,style: TextStyle(color: textColor),),
          onPressed:  () {
            onPressed();
          },
          style: OutlinedButton.styleFrom(
            textStyle: TextStyle(
             color: Colors.deepPurple
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2, color: Colors.green),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

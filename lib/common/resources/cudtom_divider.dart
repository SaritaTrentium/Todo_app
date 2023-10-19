import 'package:flutter/material.dart';
class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

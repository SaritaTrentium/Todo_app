import 'package:flutter/material.dart';
class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      // Other scaffold properties
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            child: CircularProgressIndicator(),
          ),
          // Your other UI elements
        ],
      ),
    );
  }
}

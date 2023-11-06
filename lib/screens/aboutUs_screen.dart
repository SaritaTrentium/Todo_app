import 'package:flutter/material.dart';
import 'package:todo_app/common/custom_appbar.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'About Us',
      ),
      body: Center(
        child: Text('This is the About Us page content.'),
      ),
    );
  }
}

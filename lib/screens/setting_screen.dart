import 'package:flutter/material.dart';
import 'package:todo_app/common/custom_appbar.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.brush),
            title: Text('Change app color'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.font_download),
            title: Text('Change app typography'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Change app language'),
            trailing: Icon(Icons.navigate_next),
          ),
          Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Import',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Import from Google calendar'),
            trailing: Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}

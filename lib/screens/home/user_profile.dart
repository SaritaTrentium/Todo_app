import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/profile_listview_model.dart';
class UserPanelScreen extends StatefulWidget {
  const UserPanelScreen({super.key});

  @override
  State<UserPanelScreen> createState() => _UserPanelScreenState();
}

class _UserPanelScreenState extends State<UserPanelScreen> {
  late PageController _pageController;
  String? userName;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    final user = FirebaseAuth.instance.currentUser;
    userName = user != null ? user.displayName : null;
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildUserPanel(),
    );
  }

  Widget _buildUserPanel() {
    final brightness = Theme.of(context).brightness;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        if (userName != null)
          Container(
            width: 100,
            height: 100,
            child: CircleAvatar(
              child: Text(
                userName!.isNotEmpty ? userName![0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 60,
                  color: brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.deepPurple,
                ),
              ),
              backgroundColor: brightness == Brightness.dark
                  ? Colors.grey
                  : Colors.deepPurple.shade100,
            ),
          ),
        const SizedBox(height: 20),
        Text(userName!,style: TextStyle(
          fontSize: 30,
          color: brightness == Brightness.dark
              ? Colors.white54
              : Colors.deepPurple,
        ),),
        const SizedBox(height: 40),
        Expanded(
          child: ListView.builder(
              itemCount: profileView.length,
              itemBuilder: (context, index){
                final item = profileView[index];
                return ListTile(
                  leading: item.leading,
                  title: Text(item.title),
                  trailing: item.trailing,
                  onTap: (){
                    if (item.onTap != null) {
                      item.onTap!(context);
                    }
                  },
                );
              }),
        ),
      ],
    );
  }
}

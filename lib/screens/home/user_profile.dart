import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/common/Custom_bottom_navigation.dart';
import 'package:todo_app/common/custom_appbar.dart';
import 'package:todo_app/common/resources/string_resources.dart';
import 'package:todo_app/models/profile_listview_model.dart';
class UserPanel extends StatefulWidget {
  const UserPanel({super.key});

  @override
  State<UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  late PageController _pageController;
  var _currentIndex= 3;
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
   // String? userName = FirebaseAuth.instance.currentUser!.displayName;
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: CustomAppBar(
        title: StringResources.getTodoProfileTitle,
      ),
      body: Column(
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
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle navigation based on the selected index
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

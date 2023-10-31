import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/Custom_bottom_navigation.dart';
import 'package:todo_app/common/custom_appbar.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';
import 'package:todo_app/widget/change_theme_widget.dart';
class UserPanel extends StatefulWidget {
  const UserPanel({super.key});

  @override
  State<UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  late AuthProvider _authProvider;
  var _currentIndex= 3;

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Profile',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),
          CircleAvatar(child: Image.asset('assets/home/noTodo.png'),radius: 40,),
          const SizedBox(height: 10,),
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
            leading: Icon(Icons.settings),
            title: Text('App Settings'),
            trailing: Icon(Icons.navigate_next),
            onTap: (){
              Navigator.of(context).pushNamed('/setting');
            },
          ),
          ListTile(
            leading: Icon(Icons.light_mode),
            title: Text('Set Mode Light/Dark'),
            trailing: ChangeThemeButtonWidget(),
          ),
          Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Account',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Change account name'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.key),
            title: Text('Change account password'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.camera_enhance),
            title: Text('Change account Image'),
            trailing: Icon(Icons.navigate_next),
          ),
          Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Todo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard_customize),
            title: Text('About us'),
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            trailing: Icon(Icons.navigate_next),
            onTap: () async {
              if(_authProvider.isUserSignedIn()) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null){
                  final todoBox = await Hive.box<Todo>('todos_${user.email}');
                  await todoBox.close();
                  _authProvider.signOut();
                  saveLoginState(false);
                  print('User sign out for this email------${user.email}');
                  Navigator.of(context).pushReplacementNamed('/login');
                  }else {
                    print("User Not Signed In.");
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                } else{
                    print("Go to the Login Page");
                    Navigator.of(context).pushReplacementNamed('/login');
                }
            },
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

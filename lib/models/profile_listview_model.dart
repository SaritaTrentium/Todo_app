import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/resources/string_resources.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/theme_changer_provider.dart';
import 'package:todo_app/widget/change_theme_widget.dart';

class ProfileViewModel{
  final Icon leading;
  final String title;
  final Widget trailing;
  final Function(BuildContext)? onTap;
  const ProfileViewModel({required this.leading, required this.title, required this.trailing,this.onTap});
}

List<ProfileViewModel> profileView= [
  ProfileViewModel(leading: Icon(Icons.light_mode), title: StringResources.getThemeTitle, trailing: ChangeThemeButtonWidget(),
      onTap: (context){
        Navigator.of(context).pushNamed('/theme');
      }),
  ProfileViewModel(leading: Icon(Icons.dashboard_customize), title: StringResources.getAboutUsTitle, trailing: Icon(Icons.navigate_next),
      onTap: (context){
        Navigator.of(context).pushNamed('/aboutUs');
  }),
  ProfileViewModel(leading: Icon(Icons.logout), title: StringResources.getLogOut, trailing: Icon(Icons.navigate_next),
      onTap: (context){
        _showSignOutConfirmationDialog(context);
     }
  ),
];

Future<void> _showSignOutConfirmationDialog(BuildContext context) async {
  late AuthProvider _authProvider;
  late ThemeChangerProvider _themeProvider;
  _authProvider = Provider.of<AuthProvider>(context, listen: false);
  _themeProvider = Provider.of<ThemeChangerProvider>(context, listen: false);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(StringResources.getAskSignOut),
        content: Text(StringResources.getSureSignOut),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Dismiss the dialog.
              Navigator.of(context).pop();
            },
            child: Text(StringResources.getCancel),
          ),
          TextButton(
            onPressed: () async {
              print('SignOut user : ${FirebaseAuth.instance.currentUser?.displayName}');
              // Sign out the user and handle the sign-out result.
              await _authProvider.signOut();

              // Dismiss the confirmation dialog.
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/login');
              _themeProvider.resetThemeMode();
            },
            child: Text(StringResources.getSignOut),
          ),
        ],
      );
    },
  );
}

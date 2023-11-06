import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  ProfileViewModel(leading: Icon(Icons.light_mode), title: 'Theme', trailing: ChangeThemeButtonWidget(),
      onTap: (context){
        Navigator.of(context).pushNamed('/theme');
      }),
  ProfileViewModel(leading: Icon(Icons.dashboard_customize), title: 'About us', trailing: Icon(Icons.navigate_next),
      onTap: (context){
        Navigator.of(context).pushNamed('/aboutUs');
  }),
  ProfileViewModel(leading: Icon(Icons.logout), title: 'Log out', trailing: Icon(Icons.navigate_next),
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
        title: Text('Sign Out Confirmation'),
        content: Text('Are you sure you want to sign out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Dismiss the dialog.
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Sign out the user and handle the sign-out result.
              bool signOutSuccessful = await _authProvider.signOut();

              // Dismiss the confirmation dialog.
              Navigator.of(context).pop();
              _themeProvider.resetThemeMode();
              // Display a message based on the sign-out result.
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(signOutSuccessful ? 'Sign Out Successful' : 'Sign Out Failed'),
                    content: Text(signOutSuccessful ? 'You have been signed out.' : 'Unable to sign out. Please try again.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/login');
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Sign Out'),
          ),
        ],
      );
    },
  );
}

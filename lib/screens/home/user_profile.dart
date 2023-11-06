import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/Custom_bottom_navigation.dart';
import 'package:todo_app/common/custom_appbar.dart';
import 'package:todo_app/models/profile_listview_model.dart';
import 'package:todo_app/providers/auth_provider.dart';
class UserPanel extends StatefulWidget {
  const UserPanel({super.key});

  @override
  State<UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  late PageController _pageController;
  late AuthProvider _authProvider;
  var _currentIndex= 3;
  String? userName = FirebaseAuth.instance.currentUser!.displayName;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            width: 120,
            height: 120,
            child: ClipRRect(borderRadius: BorderRadius.circular(100),child: const Image(image: AssetImage('assets/home/noTodo.png')),),
          ),
          const SizedBox(height: 10),
          Text(userName!,style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.deepPurple),),
          const SizedBox(height: 10),
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

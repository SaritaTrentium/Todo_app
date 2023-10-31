import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomBottomNavigation({super.key, required this.currentIndex, required this.onTap});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black26
          : Colors.deepPurple.shade400,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(.60),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      onTap: (value){
        switch (value){
          case 0:
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case 1:
            Navigator.of(context).pushReplacementNamed('/addTodo');
            break;
          case 2:
            Navigator.of(context).pushReplacementNamed('/taskComplete');
            break;
          case 3:
            Navigator.of(context).pushReplacementNamed('/userPanel');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          label : 'Home',
          icon: Icon(Icons.home_outlined),
        ),
        BottomNavigationBarItem(
          label : 'Add Todo',
          icon: Icon(Icons.add),
        ),
        BottomNavigationBarItem(
          label : 'Task Complete',
          icon: Icon(Icons.task),
        ),
        BottomNavigationBarItem(
          label : 'User Panel',
          icon: Icon(Icons.account_circle),
        ),
      ],
    );
  }
}

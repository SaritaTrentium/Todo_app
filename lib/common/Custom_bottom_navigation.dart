import 'package:flutter/material.dart';
import 'package:todo_app/common/resources/string_resources.dart';

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
      selectedFontSize: 16,
      unselectedFontSize: 14,
      currentIndex: widget.currentIndex,
      onTap: (value){
        switch (value){
          case 0:
            Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
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
          label : StringResources.getTodoHomeTitle,
          icon: Icon(Icons.home_outlined),
        ),
        BottomNavigationBarItem(
          label : StringResources.getTodoAddTodoTitle,
          icon: Icon(Icons.add),
        ),
        BottomNavigationBarItem(
          label : StringResources.getTodoTaskCompleteTitle,
          icon: Icon(Icons.task),
        ),
        BottomNavigationBarItem(
          label : StringResources.getTodoProfileTitle,
          icon: Icon(Icons.account_circle),
        ),
      ],
    );
  }
}

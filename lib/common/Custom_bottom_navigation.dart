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
      type: BottomNavigationBarType.shifting,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.deepPurple.withOpacity(.60),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 16,
      unselectedFontSize: 14,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: [
        BottomNavigationBarItem(
          label: StringResources.getTodoHomeTitle,
          icon: Icon(Icons.home_outlined),
        ),
        BottomNavigationBarItem(
          label: StringResources.getTodoAddTodoTitle,
          icon: Icon(Icons.add),
        ),
        BottomNavigationBarItem(
          label: StringResources.getTodoTaskCompleteTitle,
          icon: Icon(Icons.task),
        ),
        BottomNavigationBarItem(
          label: StringResources.getTodoProfileTitle,
          icon: Icon(Icons.account_circle),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool? centerTitle;
  final IconButton? iconButton;
  const CustomAppBar({super.key, required this.title,this.actions, this.centerTitle, this.iconButton});

  @override
  Size get  preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
          title: Text(title),
          actions: actions,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
      ? Colors.black26
      : Colors.deepPurple.shade400,
        );
  }
}

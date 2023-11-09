import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/theme_changer_provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    late ThemeChangerProvider _themeProvider;
    _themeProvider = Provider.of<ThemeChangerProvider>(context, listen: false);
    return GestureDetector(
      onTap: (){
        _themeProvider.toggleTheme();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _themeProvider.themeMode == ThemeMode.dark
              ? Colors.black
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.brightness_6,
              color: _themeProvider.themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
            SizedBox(width: 5),
            Text(
              _themeProvider.themeMode == ThemeMode.dark ? 'Light' : 'Dark',
              style: TextStyle(
                color: _themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

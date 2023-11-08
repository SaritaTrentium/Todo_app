import 'package:flutter/material.dart';
import 'package:todo_app/common/Custom_bottom_navigation.dart';
import 'package:todo_app/common/custom_appbar.dart';
import 'package:todo_app/common/resources/string_resources.dart';
import 'package:todo_app/common/view_mode.dart';
import 'package:todo_app/screens/home/add_todo_screen.dart';
import 'package:todo_app/screens/home/home_screen.dart';
import 'package:todo_app/screens/home/task_complete.dart';
import 'package:todo_app/screens/home/user_profile.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ViewMode currentViewMode = ViewMode.ListView;
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    TodoScreen(),
    TaskCompleteScreen(),
    UserPanelScreen(),
  ];

  List<String> screenTitles = [
    StringResources.getTodoHomeTitle,
    StringResources.getTodoAddTodoTitle,
    StringResources.getTodoTaskCompleteTitle,
    StringResources.getTodoProfileTitle,
  ];
  @override
  Widget build(BuildContext context) {
    bool isSearching = false;
    final isHomeScreen = _selectedIndex == 0;
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: CustomAppBar(
        title: screenTitles.elementAt(_selectedIndex),
        actions: isHomeScreen
        ? [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            child: IconButton(onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
              Navigator.of(context).pushNamed('/search');
            }, icon: Icon(Icons.search)),
          ),
          PopupMenuButton(itemBuilder: (context){
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Text(StringResources.getGridView,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: brightness == Brightness.dark
                        ? currentViewMode == ViewMode.GridView ? Colors.white : Colors.white38
                        : currentViewMode == ViewMode.GridView ? Colors.deepPurple : Colors.deepPurple.shade200,),
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text(StringResources.getListView,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: brightness == Brightness.dark
                        ? currentViewMode == ViewMode.ListView ? Colors.white : Colors.white38
                        : currentViewMode == ViewMode.ListView ? Colors.deepPurple : Colors.deepPurple.shade200,),
                ),
              ),
            ];
          },
            onSelected: (value){
              setState(() {
                if(value == 0){
                  currentViewMode = ViewMode.GridView;
                }else{
                  currentViewMode = ViewMode.ListView;
                }
              });
            },
          ),
        ]
       : null,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

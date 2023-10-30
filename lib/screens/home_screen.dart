import 'package:flutter/material.dart';
import 'package:todo_app/common/custom_appbar.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Todo List',
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed('/search');
          }, icon: Icon(Icons.search)),
          PopupMenuButton(itemBuilder: (context){
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Text('Grid View',style: TextStyle(fontSize: 16,color: Colors.deepPurple, fontWeight: FontWeight.bold),),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text('List View',style: TextStyle(fontSize: 16,color: Colors.deepPurple,fontWeight: FontWeight.bold)),),
            ];
          },
          onSelected: (value){
            if(value ==0){

            }else{

            }
          },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurple.shade300,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value){
          // switch (value){
          //   case 0
          // }
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
      ),
    );
  }
}


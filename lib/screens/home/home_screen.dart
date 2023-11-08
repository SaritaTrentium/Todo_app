import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_appbar.dart';
import 'package:todo_app/common/resources/string_resources.dart';
import 'package:todo_app/common/view_mode.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/widget/viewMode_widget.dart';
import '../../services/notification_services.dart';
import 'package:timezone/data/latest.dart' as tz;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  var logger;
  late TodoListProvider _todoListProvider;
  late List<Todo> filteredTodos = [];
  String? query;

  @override
  void initState() {
    super.initState();
    NotificationServices.initializeNotification();
    tz.initializeTimeZones();
    setState(() {
      checkUsersTodo();
    });
  }

  Future<void> checkUsersTodo() async {
    _todoListProvider = Provider.of<TodoListProvider>(context, listen: false);
    final user = await FirebaseAuth.instance.currentUser;
    if(user != null){
      query = '';
      Hive.openBox<Todo>('todos_${user.email}');
      filteredTodos = <Todo>[];
      _todoListProvider.fetchUserTodos(user.email).then((todos) {
        setState(() {
          filteredTodos = todos;
        });
      });
    } else{
      setState(() {
        print("User is null. Try to sign in");
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildHomeScreen(),
    );
  }

  Widget _buildHomeScreen() {
    ViewMode currentViewMode = ViewMode.ListView;
    return SafeArea(
      child: Column (
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<TodoListProvider>(
              builder: (context, todoListProvider, _) {
                if (filteredTodos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/home/noTodo.png',height: 200,width: 200,),
                        Text("What do you want to do today?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10,),
                        Text("Tap + to add your tasks", style: TextStyle(fontSize: 16),),
                      ],
                    ),
                  );
                }
                else {
                  return  currentViewMode == ViewMode.GridView
                      ? TodoUtils.buildGridView(filteredTodos, todoListProvider, context)
                      : TodoUtils.buildListView(filteredTodos, todoListProvider, context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}



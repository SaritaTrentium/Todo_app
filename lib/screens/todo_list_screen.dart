import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/login_page.dart';
import 'package:todo_app/pages/todo_page.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';
import 'package:todo_app/widget/change_theme_widget.dart';

import '../providers/auth_provider.dart';
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}
class _TodoListPageState extends State<TodoListPage> {
  late AuthProvider _authProvider;
  late TodoListProvider _todoListProvider;
  late List<Todo> filteredTodos = [];
  String? query;

  @override
  void initState() {
     super.initState();
     checkUsersTodo();
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
      print(filteredTodos);
      print('Filter data when Before initialized time: ${user.email} ${_todoListProvider.todos.length}');
      print('Filter data when after initialized time: ${_todoListProvider.todos}');
    } else{
      setState(() {
        print("User is null. Try to sign in");
      });
    }

  }

  @override
  void dispose() {
    super.dispose();
    filteredTodos;
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    _todoListProvider = Provider.of<TodoListProvider>(context, listen: false);
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TodoPage()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Todo Info'),
        actions: [
          ChangeThemeButtonWidget(),
          IconButton(onPressed: () async {
            if(_authProvider.isUserSignedIn()) {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null){
                final todoBox = await Hive.box<Todo>('todos_${user.email}');
                await todoBox.close();
                _authProvider.signOut();
                saveLoginState(false);
                print('User sign out for this email------${user.email}');
                Navigator.of(context).pushNamed('/');
              }else {
                print("User Not Signed In.");
                Navigator.of(context).pushNamed('/');
              }
            } else{
              print("Go to the Login Page");
              Navigator.of(context).pushNamed('/');
            }
          }, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: Column (
        children: [
          const SizedBox(height: 10),
          TextField(
            controller: searchController, // Make sure to add this line
            onChanged: (query) async {
              filteredTodos = await _todoListProvider.fetchSearchTodos(query);
              print('fetch data when query not null ---$filteredTodos');
            },
            decoration: InputDecoration(
              labelText: "Search Todo",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<TodoListProvider>(
            builder: (context, todoListProvider, _) {
              // Use the todos data in your UI
              if (filteredTodos.isEmpty) {
                return const Center(
                  child: Text("No Todo Yet.", style: TextStyle(fontSize: 20),),
                );
              }
              else {
                return buildTodoList(filteredTodos);
              }
            },
          ),
          ),
        ],
      ),
    );
  }

  Widget buildTodoList(List<Todo> filteredTodos) {
    final _formKey = GlobalKey<FormState>();
   _todoListProvider = Provider.of<TodoListProvider>(context, listen: false);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: filteredTodos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value:filteredTodos[index].isCompleted,
                      onChanged: (bool? newValue) {
                        if(newValue != null){
                          setState(() {
                            filteredTodos[index].isCompleted = newValue;
                          });
                          _todoListProvider.updateTodoCompletion(filteredTodos[index], newValue);
                          print('Checkbox value is: $newValue');
                        }else {
                          print("checkbox value null");
                        }
                      },
                    ),
                    title: Text(filteredTodos[index].title,
                      style: TextStyle(decoration: filteredTodos[index].isCompleted!
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      ),),
                    subtitle: Text(filteredTodos[index].desc),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                          final  user = FirebaseAuth.instance.currentUser;
                          if(user != null){
                            final todoBox = Hive.box<Todo>('todos_${user.email}');
                            try{
                              setState(() {
                                _todoListProvider.deleteTodo(index);
                                todoBox.deleteAt(index);
                              });
                            } catch(error){
                              print('Error deleting todo: $error');
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Delete Successfully"),),);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("You are not signed in."),
                              ),
                            );
                          }
                        }, icon: const Icon(Icons.delete)),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
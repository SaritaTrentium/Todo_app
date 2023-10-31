import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_appbar.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
import 'package:todo_app/services/auth_isUserLoggedIn.dart';
import 'package:todo_app/widget/change_theme_widget.dart';
import '../providers/auth_provider.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}
class _TodoListScreenState extends State<TodoListScreen> {
  @override
  var logger;
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
          filteredTodos = todos;
      });
    } else{
      setState(() {
        print("User is null. Try to sign in");
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    _todoListProvider = Provider.of<TodoListProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black26
            : Colors.deepPurple.shade400,
        onPressed: () {
          Navigator.of(context).pushNamed('/addTodo');
        },
        child: const Icon(Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: CustomAppBar(
        title: 'Todo Info',
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
              Navigator.of(context).pushReplacementNamed('/login');
            }else {
              print("User Not Signed In.");
              Navigator.of(context).pushReplacementNamed('/login');
            }
          } else{
            print("Go to the Login Page");
            Navigator.of(context).pushReplacementNamed('/login');
          }
        }, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: SafeArea(
        child: Column (
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
              child: TextField(
                onChanged: (query) async {
                  filteredTodos = await _todoListProvider.fetchSearchTodos(query);
                },
                decoration: InputDecoration(
                  labelText: "Search Todo",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<TodoListProvider>(
              builder: (context, todoListProvider, _) {
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
                          showDialog(context: context, builder: (BuildContext context){
                            return AlertDialog(
                              title: Text("Delete Confirmation"),
                              content: Text("Are you sure you want to delete this ${filteredTodos[index].title} item?"),
                              actions: <Widget>[
                                TextButton(onPressed: (){
                                  Navigator.of(context).pop();
                                }, child: Text("Cancel")),
                                TextButton(onPressed: (){
                                  final user = FirebaseAuth.instance.currentUser;
                                  if(user != null){
                                    setState(() {
                                     // _todoListProvider.deleteTodo(todo);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete Successfully ${filteredTodos[index].title}"),),);
                                  } else{
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Delete not working properly"),),);
                                  }
                                  Navigator.of(context).pop();
                                }, child: Text("Delete"))
                              ],
                            );
                          });
                        }, icon: const Icon(Icons.delete),),
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
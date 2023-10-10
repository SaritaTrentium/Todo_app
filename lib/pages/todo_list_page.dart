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


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final todoListProvider = Provider.of<TodoListProvider>(context, listen: false);

    final user = FirebaseAuth.instance.currentUser;
    try{
      if (user != null){
        print('Current User Login: ${user.email}');
        setState(() {
          Hive.openBox<Todo>('todos_${user.email}');
          todoListProvider.fetchUserTodos(user.email);
        });
      } else {
        setState(() {
          authProvider.isUserSignedIn();
        });
        print("User is null. try to signUp");
      }
    }catch(error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }

   // final todos = todoListProvider.todos;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoPage()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Todo Info'),
        actions: [
          ChangeThemeButtonWidget(),
          IconButton(onPressed: () async {
            if(authProvider.isUserSignedIn()) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null){
                  final todoBox = await Hive.box<Todo>('todos_${user.email}');
                  await todoBox.close();
                  authProvider.signOut();
                  saveLoginState(false);
                  print('User sign out for this email------${user.email}');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }else {
                  print("User Not Signed In.");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
            } else{
                print("Go to the Login Page");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
            }
          }, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: Consumer<TodoListProvider>(
        builder: (context, todoListProvider, _) {
          final todos = todoListProvider.todos;
          print('Store todoItems Length -----${todos.length}');

          // Use the todos data in your UI
          if (todos.isEmpty) {
            return const Center(
              child: Text("No Todo Yet.", style: TextStyle(fontSize: 20),),
            );
          }
          else {
            return buildTodoList(todos);
          }
        },
      ),
    );
  }

  Widget buildTodoList(List<Todo> todos) {
    final _formKey = GlobalKey<FormState>();
    final todoListProvider = Provider.of<TodoListProvider>(context, listen: false);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: todos[index].isCompleted,
                      onChanged: (bool? newValue) {
                        if(newValue != null){
                          setState(() {
                            todos[index].isCompleted = newValue;
                          });
                          todoListProvider.updateTodoCompletion(todos[index], newValue);
                          print('Checkbox value is: $newValue');
                        }else {
                          print("checkbox value null");
                        }
                      },
                    ),
                    title: Text(todos[index].title,
                        style: TextStyle(decoration: todos[index].isCompleted!
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        ),),
                    subtitle: Text(todos[index].desc),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                          final  user = FirebaseAuth.instance.currentUser;
                          if(user != null){
                            final todoBox = Hive.box<Todo>('todos_${user.email}');
                            try{
                              setState(() {
                                todoListProvider.deleteTodo(index);
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
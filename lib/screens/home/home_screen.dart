import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/Custom_bottom_navigation.dart';
import 'package:todo_app/common/custom_appbar.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isGridView = false;
  int _currentIndex = 0;
  var logger;
  late TodoListProvider _todoListProvider;
  late List<Todo> filteredTodos = [];
  String? query;
  @override
  void initState() {
    super.initState();
    checkUsersTodo();
    isGridView = false;
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
    bool isSearching = false;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Todo',
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
           // width: isSearching ? double.infinity : 30,
            child: IconButton(onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            }, icon: Icon(Icons.search)),
          ),
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
              setState(() {
                isGridView = true;
              });
            }else{
              setState(() {
                isGridView = false;
              });
            }
          },
          ),
        ],
      ),
      body: SafeArea(
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
                    if(isGridView){
                      return buildGridView(filteredTodos);
                    }
                    else{
                      return buildListView(filteredTodos);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
  Widget buildTodoItem(Todo todo) {
    final _formKey = GlobalKey<FormState>();
    _todoListProvider = Provider.of<TodoListProvider>(context, listen: false);
    return Form(
      key: _formKey,
      child: Container(
        height: 80,
        width: 80,
        child: Column(
          children: [
            Expanded(
            child: Card(
              elevation: 2.0,
              child: ListTile(
                        leading: Checkbox(
                          value:todo.isCompleted,
                          activeColor: Colors.deepPurple,
                          onChanged: (bool? newValue) {
                            if(newValue != null){
                              setState(() {
                                todo.isCompleted = newValue;
                              });
                              _todoListProvider.updateTodoCompletion(todo, newValue);
                            }else {
                              print("checkbox value null");
                            }
                          },
                        ),
                        title: Text(todo.title,
                          style: TextStyle(decoration: todo.isCompleted!
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          ),),
                        subtitle: Text(todo.desc),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: () {
                              showDialog(context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("Delete Confirmation"),
                                  content: Text("Are you sure you want to delete this ${todo.title} item?"),
                                  actions: <Widget>[
                                    TextButton(onPressed: (){
                                      Navigator.of(context).pop();
                                    }, child: Text("Cancel")),
                                    TextButton(onPressed: (){
                                      final user = FirebaseAuth.instance.currentUser;
                                      if(user != null){
                                        setState(() {
                                          _todoListProvider.deleteTodo(todo);
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete Successfully ${todo.title}"),),);
                                      } else{
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Delete not working properly"),),);
                                      }
                                      Navigator.of(context).pop();
                                    }, child: Text("Delete"))
                                  ],
                                );
                              });
                            }, icon: const Icon(
                              Icons.delete,
                              //color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.deepPurple,
                            ),),
                          ],
                        ),
                      ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView(List<Todo> filteredTodos) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: filteredTodos.length,
      itemBuilder: (context, index) {
        return buildTodoItem(filteredTodos[index]); // Pass the individual todo item
      },
    );
  }
  Widget buildListView(List<Todo> filteredTodos) {
    return ListView.builder(
      itemCount: filteredTodos.length,
      itemBuilder: (context, index) {
        return buildTodoItem(filteredTodos[index]); // Pass the individual todo item
      },
    );
  }
}



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/custom_appbar.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_list_provider.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TodoListProvider _todoListProvider;
  late Future<List<Todo>> filteredTodos;
  late String query = '';

  @override
  void initState() {
    super.initState();
    filteredTodos = Future.value([]); // Initialize with an empty list
  }

  @override
  Widget build(BuildContext context) {
    String? query;
    _todoListProvider = Provider.of<TodoListProvider>(context,);
    return Scaffold(
      appBar: CustomAppBar(title: 'Search Todo',
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    query = value;
                    if(query!.isEmpty){
                      filteredTodos = Future.value([]);
                    }else{
                      filteredTodos = _todoListProvider.fetchSearchTodos(query);
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: "Search Todo",
                  prefixIcon: Icon(Icons.search),
                  suffix: (query != null && query.isNotEmpty)
                          ? IconButton(onPressed: () {
                              setState(() {
                                query = '';
                              });
                              }, icon: Icon(Icons.clear))
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child:Consumer<TodoListProvider>(
                  builder: (context, _todoListProvider, _){
                    return FutureBuilder(
                        future: filteredTodos,
                        builder: (context, snapshot){
                           if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // or a loading indicator
                           } else if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                               return Center(
                                  child: Text(
                                    "No todo found matching.",
                                    style: TextStyle(fontSize: 20),
                                   ),
                                );
                            } else {
                              // Return a widget that displays the filteredTodos
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 2.0,
                                    margin: EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: Checkbox(
                                        value: snapshot.data![index].isCompleted,
                                        activeColor: Colors.deepPurple,
                                        onChanged: (bool? newValue) {
                                          if (newValue != null) {
                                            snapshot.data![index].isCompleted = newValue;
                                            _todoListProvider.updateTodoCompletion(snapshot.data![index], newValue);
                                          } else {
                                            print("checkbox value null");
                                          }
                                        },
                                      ),
                                      title: Text(
                                        snapshot.data![index].title,
                                        style: TextStyle(
                                          decoration: snapshot.data![index].isCompleted!
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                      subtitle: Text(snapshot.data![index].desc),
                                      trailing: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Delete Confirmation"),
                                                content: Text("Are you sure you want to delete this ${snapshot.data![index].title} item?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      final user = FirebaseAuth.instance.currentUser;
                                                      if (user != null) {
                                                        _todoListProvider.deleteTodo(snapshot.data![index]);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                "Delete Successfully ${snapshot.data![index].title}"),
                                                          ),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text("Delete not working properly"),
                                                          ),
                                                        );
                                                      }
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("Delete"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete, // Change the delete button color
                                        ),
                                      ),
                                    ),
                                  );
                              },
                              );
                            }
                          } else {
                            return Text("Error loading Todos");
                            }
                          });
                  },
                ),
            ),
         ],
        ),
      ),
    );
  }
}

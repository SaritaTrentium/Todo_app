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
  late List<Todo> filteredTodos = [];
  @override
  Widget build(BuildContext context) {
    _todoListProvider = Provider.of<TodoListProvider>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(title: 'Search Todo',
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
              child: Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Search Todo",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
                      // Expanded(
                      //   child: Consumer<TodoListProvider>(
                      //   builder: (context, todoListProvider, _) {
                      //     if (filteredTodos.isEmpty) {
                      //       return const Center(
                      //         child: Text("No todo found matching.", style: TextStyle(fontSize: 20),),
                      //       );
                      //     }
                      //     else {
                      //       //return filteredTodos;
                      //     }
                      //   },
                      // ),
                      // ),
          ],
        ),
      ),
    );
  }
}

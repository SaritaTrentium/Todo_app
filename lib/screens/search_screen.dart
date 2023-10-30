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
      appBar: CustomAppBar(title: '',
        actions: [
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
        ],
      ),
      body: Container(
        height: 200,
        width: 200,
        child: Column(
          children: [
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/todo_model.dart';

class TodoListProvider extends ChangeNotifier {
  final String _todoBoxName = 'todos'; // Name of the Hive box

  late Box<Todo> _todoBox;

  List<Todo> get todos => _todoBox.values.toList();

  TodoListProvider() {
    _initHive();
  }
  // _todoBox is initialized in the _initHive method, which is called when the
  // TodoListProvider is created. It opens a Hive box of type Todo and assigns it to _todoBox.
  Future<void> _initHive() async {
    await Hive.openBox<Todo>(_todoBoxName);
    _todoBox = Hive.box<Todo>(_todoBoxName);
    notifyListeners();
  }

  // AddTodo method to add data
  void addTodo(Todo todo){
    _todoBox.add(todo);
    notifyListeners();
  }

  // Your DeleteTodo method to delete data at a specific index
  void DeleteTodo(int index) {
    if (index >= 0 && index < _todoBox.length) {
      _todoBox.deleteAt(index);
      notifyListeners();
    }
  }
}

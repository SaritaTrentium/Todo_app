import 'package:flutter/material.dart';
import 'package:todo_app/services/todo_service.dart';
import '../models/todo_model.dart';

class TodoListProvider extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  final String _todoBoxName = 'todos';

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  Future<List<Todo>> fetchUserTodos(String? userEmail) async {
    if (userEmail == null) {
      return [];
    }

    _todos = await _todoService.fetchUserTodos(userEmail);
    notifyListeners();
    return _todos;
  }

  Future<void> addTodo(Todo todo) async {
    await _todoService.addTodo(todo);
    _todos.add(todo);
    notifyListeners();
  }

  Future<void> deleteTodo(int index) async {
    final todoId = _todos[index].userId;
    await _todoService.deleteTodo(todoId);
    _todos.removeAt(index);
    notifyListeners();
  }

  // Future<void> updateTodoCompletion(Todo todo, bool isCompleted) async {
  //   final todoId = todo.userId;
  //   await _todoService.updateTodoCompletion(todoId as Todo, isCompleted);
  //   final todoIndex = _todos.indexWhere((element) => element.userId == todoId);
  //   if (todoIndex != -1) {
  //     _todos[todoIndex].isCompleted = isCompleted;
  //     notifyListeners();
  //   }
  // }
}

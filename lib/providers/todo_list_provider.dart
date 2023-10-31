import 'package:flutter/material.dart';
import 'package:todo_app/services/todo_service.dart';
import '../models/todo_model.dart';

class TodoListProvider extends ChangeNotifier {
  final TodoService _todoService = TodoService();

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  List<Todo> _filteredTodos = [];
  List<Todo> get filteredTodos => _filteredTodos;

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

  Future<void> deleteTodo(Todo todo) async {
    final todoId = todo.userId;
    await _todoService.deleteTodo(todoId);
    _todos.remove(todo);
    notifyListeners();
  }

  Future<void> updateTodoCompletion(Todo todo, bool isCompleted) async{
    print('UserId when update icCompleted : ${todo.userId}');
    final todoId= todo.userId;
    await _todoService.updateTodoCompletion(todo, isCompleted);
    final todoIndex = _todos.indexWhere((todoUpdate) => todoUpdate.userId == todoId);
    if(todoIndex != -1){
      _todos[todoIndex].isCompleted = isCompleted;
      notifyListeners();
    }
  }
  Future<List<Todo>> fetchSearchTodos(String? query) async {
    if(query == null || query.isEmpty){
      _filteredTodos = _todos;
    }else{
      _filteredTodos = _todos.where((todos)
      => todos.title.toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    }
      notifyListeners();
      return _filteredTodos;
  }
}

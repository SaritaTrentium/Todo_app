import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo_model.dart';

class TodoService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Todo>> fetchUserTodos(String userEmail) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userEmail)
          .collection('todos')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Todo(
          userId: doc.id,
          title: data['title'] ?? '',
          desc: data['description'] ?? '',
          isCompleted: data['isCompleted'] ?? false,
          deadline: null,
        );
      }).toList();
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await _firestore
          .collection('users')
          .doc(user!.email)
          .collection('todos')
          .add({
        'title': todo.title,
        'description': todo.desc,
        'isCompleted': todo.isCompleted,
        'deadline': todo.deadline,
      });
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> deleteTodo(String todoId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await _firestore
          .collection('users')
          .doc(user!.email)
          .collection('todos')
          .doc(todoId)
          .delete();
    } catch (error) {
      throw error.toString();
    }
  }
 }

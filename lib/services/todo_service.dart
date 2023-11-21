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
          .orderBy('title')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Todo(
          id: doc.hashCode,
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
      if(user != null){
        await _firestore
            .collection('users')
            .doc(user.email)
            .collection('todos')
            .add({
          'title': todo.title,
          'description': todo.desc,
          'isCompleted': todo.isCompleted,
          'deadline': todo.deadline,
        });
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> deleteTodo(String todoId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if(user != null){
        await _firestore
            .collection('users')
            .doc(user.email)
            .collection('todos')
            .doc(todoId)
            .delete();
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updateTodoCompletion(Todo todo, bool isCompleted) async{
    try{
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('users')
            .doc(user.email)
            .collection('todos')
            .doc(todo.userId)
            .update({'isCompleted': isCompleted});
      }
    }catch(error){
      throw error.toString();
    }
  }

  Future<void> notificationDetails(Todo todo)async{
    try {
      final user = FirebaseAuth.instance.currentUser;
      if(user != null){
        await _firestore
            .collection('notification')
            .doc(user.email)
            .collection('notifyDetails')
            .add({
          'title': todo.title,
          'deadline': todo.deadline,
        });
      }
    } catch (error) {
      throw error.toString();
    }
  }

  // Future<List<Todo>> fetchSearchTodos(String userEmail, String query) async{
  //   try{
  //     final QuerySnapshot querySnapshot = await _firestore
  //         .collection('users')
  //         .doc(userEmail)
  //         .collection('todos')
  //         .where('title',isGreaterThanOrEqualTo: query)
  //         .get();
  //
  //     final List<Todo> searchResults = querySnapshot.docs.map((doc) {
  //       return Todo(
  //         title: doc['title'] ?? '',
  //         desc: doc['description'] ?? '',
  //         isCompleted: doc['isCompleted'] ?? false,
  //         deadline: null,
  //         userId: doc.id,
  //       );
  //     }).toList();
  //     return searchResults;
  //   } catch (error){
  //       throw Future.error.toString();
  //   }
  //}
 }

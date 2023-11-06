import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/todo_model.dart';


class FirestoreServices{

  static Future<void> saveUser(String userEmail, uid)async {
    await FirebaseFirestore.instance
        .collection('users')
        .add({
        'title': 'title',
        'description': 'description',
      'userEmail': userEmail,
    });
  }

  static Stream<List<Todo>> getUserData(String userEmail) {
    return FirebaseFirestore.instance
          .collection('users')
          .where('userEmail', isEqualTo: userEmail)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
          .map((doc) => Todo(
        title: doc['title'],
        desc: doc['description'], deadline: doc['deadline'], userId: doc['userId'],
      )).toList());
    }
  }

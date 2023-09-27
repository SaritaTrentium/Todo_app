import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreServices{

  static saveUser(String name,email,password, uid)async {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
          {'name': name,'email': email, 'password': password});
  }
}
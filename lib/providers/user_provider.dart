import 'package:flutter/material.dart';

class UserModelProvider extends ChangeNotifier{
     String name="";
     String email="";
     String password="";

    void signUp(String name,String email, String pwd){
        this.name = name;
        this.email = email;
        this.password = password;
        notifyListeners();
    }

}
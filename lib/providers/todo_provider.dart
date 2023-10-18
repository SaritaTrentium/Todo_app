import 'package:flutter/material.dart';

class TodoProvider extends ChangeNotifier {
      String _userEmail = "";
      DateTime _selectedDateTime = DateTime.now();


      String get userEmail => _userEmail;
      DateTime get selectedDateTime => _selectedDateTime;

      void setUserEmail(String value){
            _userEmail = value;
            notifyListeners();
      }
      void updateSelectedDateTime(DateTime value){
            _selectedDateTime = value;
            notifyListeners();
      }

}
import 'package:flutter/material.dart';

class TodoPageProvider extends ChangeNotifier {
      String _userEmail = "";
      String _title="";
      String _desc = "";
      DateTime _selectedDateTime = DateTime.now();


      String get userEmail => _userEmail;
      String get title => _title;
      String get desc => _desc;
      DateTime get selectedDateTime => _selectedDateTime;

      void setUserEmail(String value){
            _userEmail = value;
            notifyListeners();
      }

      void updateTitle(String value){
            _title = value;
            notifyListeners();
      }
      void updateDesc(String value){
            _desc = value;
            notifyListeners();
      }
      void updateSelectedDateTime(DateTime value){
            _selectedDateTime = value;
            notifyListeners();
      }

}
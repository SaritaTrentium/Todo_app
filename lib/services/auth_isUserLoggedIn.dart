import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveSignUpState(bool onSignUpComplete) async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('onSignUpComplete', onSignUpComplete);
}

Future<bool> getSignUpState(bool onSignUpComplete) async{
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onSignUpComplete') ?? false;
}


  Future<void> saveLoginState(bool isLoggedIn) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isUserLoggedIn', isLoggedIn);
  }

  Future<bool> getLoginState() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isUserLoggedIn') ?? false;
  }
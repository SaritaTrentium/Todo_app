class Validator{

  static String? validateName(String value){
    if(value.isNotEmpty){
      return "Name can not be empty.";
    }
    return null;
  }

  static String? validateTitle(String value){
    if(value.isEmpty){
      return "Title can not be empty.";
    }
    return null;
  }

  static String? validateEmail(String value){
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if(value.isEmpty){
      return "Email can not be empty.";
    }
    if(!emailRegex.hasMatch(value)){
      return "Invalid email format";
    }
    return null;
  }

  static String? validatePassword(String value){
    if(value.isEmpty){
      return "Password can not be empty.";
    }
    if(value.length < 6){
      return "Password length should be at least 6.";
    }
    return null;
  }
}
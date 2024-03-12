import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{
  static String userIdKey="USERKEY";
  static String userNameKey="USERNAMEKEY";
  static String userEmailKey="USEREMAILKEY";



  //Methods to store the data
  Future<bool> saveUserId(String getUserId) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }
  Future<bool> saveUserEmail (String getUserEmail) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }


  Future<bool> saveName(String getName) async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getName);
  }


  // Methods to get the data
  Future<String?> getUserId() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }


  Future<String?> getUserEmail() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }


  Future<String?> getUserName() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

// Methods to get the data

}
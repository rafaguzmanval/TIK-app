import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_inspection_kit_app/models/user.dart';

// Class use to get and set user data
class UserProvider extends ChangeNotifier {
  // Private user variable
  User _user = new User(id: '', name: '', email: '', password: '', confirmpassword: '', token: '');

  User get user => _user;

  // It's a string because where are going to pass value
  // through response body
  void setUser(Map<String, dynamic> user){
    _user = User.fromJson(user);
    notifyListeners();
  }
}

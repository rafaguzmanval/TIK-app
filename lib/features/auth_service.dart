import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_timer_app/constants/error_handling.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/models/user.dart';
import 'package:http/http.dart';
import 'package:tree_timer_app/constants/global_variables.dart';
import 'package:tree_timer_app/models/valid_response.dart';
import 'package:tree_timer_app/providers/user_provider.dart';
import 'package:tree_timer_app/screens/home.dart';
import 'package:tree_timer_app/screens/login.dart';

class AuthService{

  // Register user
  Future registerUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password
  })
  async{

    try{
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        token: ''
      );


      Response res = await post(
        Uri.parse('$url/accounts/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );

      // return ValidResponse.fromResponse(res, res.body);
      return res;

      // httpErrorHandler(res: res, context: context,
      //   onSuccess: (){
      //     showSnackBar(context, "¡Cuenta creada correctamente!");
      //   }
      // );
    } catch(err){
      showSnackBar(context, err.toString());
    }
  }

  // Login user
  Future loginUser({
    required BuildContext context,
    required String email,
    required String password
  })
  async{

    try{
      User user = User(
        id: '',
        name: '',
        email: email,
        password: password,
        token: ''
      );


      Response res = await post(
        Uri.parse('$url/accounts/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );

      return ValidResponse.fromResponse(res, res.body);
  
    } catch(err){
      return ValidResponse(isSuccess: false, body: err.toString());
    }
  }

  void logoutUser(BuildContext context)
  async {
    try{
      if(context == null) return showSnackBar(context, "Erro al cerrar sesión");

      // We need to delete the token in order to close session
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('auth-token');

      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false
      );
    }catch(err){
      showSnackBar(context, err.toString());
    }
  }

// Get user data, for init state
  void getUserData(
    BuildContext context,
  )
  async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth-token');
      
      if(token == null){
        // That means the user initiate app for the first time in a while
        preferences.setString('auth-token', '');
      }

      Response validTokenRes = await post(
        Uri.parse('$url/accounts/checkToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': token!,
        }
      );

      bool valid = jsonDecode(validTokenRes.body);
      if(valid == true){
        // Now get user data, using middleware in server
        Response response = await get(
          Uri.parse('$url/'),
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': token ,
          }
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(jsonDecode(response.body));
      }

    } catch(err){
        print("Estoy en auth_service.dartsd");
      //showSnackBar(context, err.toString());
    }
  }
}
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/models/user.dart';
import 'package:http/http.dart';
import 'package:tree_timer_app/constants/global_variables.dart';
import 'package:tree_timer_app/models/valid_response.dart';
import 'package:tree_timer_app/providers/user_provider.dart';
import 'package:tree_timer_app/screens/login.dart';

class AuthService{

  // Establish timeout to 10 seconds
  static const int timeoutDurationSeconds = 10;

  // Register user
  Future registerUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String confirmpassword
  })
  async{
     final client = IOClient(HttpClient()..connectionTimeout = Duration(seconds: timeoutDurationSeconds));
    try{
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        confirmpassword: confirmpassword,
        token: ''
      );


      Response res = await client.post(
        Uri.parse('$url/accounts/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );
      
      return res;

    }on SocketException catch (_) {
      showFlutterToast(msg: 'Se ha excedido el tiempo límite de la solicitud', isSuccess: false);
    }catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
    }finally {
      client.close();
    }
  }

  // Login user
  Future loginUser({
    required BuildContext context,
    required String email,
    required String password
  })
  async{
    final client = IOClient(HttpClient()..connectionTimeout = Duration(seconds: timeoutDurationSeconds));
    try{
      User user = User(
        id: '',
        name: '',
        email: email,
        password: password,
        confirmpassword: '',
        token: ''
      );


      Response res = await client.post(
        Uri.parse('$url/accounts/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );

      return ValidResponse(res);
  
    }on SocketException catch (_) {
      showFlutterToast(msg: 'Se ha excedido el tiempo límite de la solicitud', isSuccess: false);
    }catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
    }finally {
      client.close();
    }
  }

  void logoutUser(BuildContext context)
  async {
    final client = IOClient(HttpClient()..connectionTimeout = Duration(seconds: timeoutDurationSeconds));
    try{
      // We need to delete the token in order to close session
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('auth-token');

      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false
      );
    }catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
    }finally {
      client.close();
    }
  }

// Get user data, for init state
  void getUserData(
    BuildContext context,
  )
  async{
    final client = IOClient(HttpClient()..connectionTimeout = Duration(seconds: timeoutDurationSeconds));
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth-token');
      
      if(token == null){
        // That means the user initiate app for the first time in a while
        preferences.setString('auth-token', '');
      }

      Response validTokenRes = await client.post(
        Uri.parse('$url/accounts/checkToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': token!,
        }
      );

      bool valid = jsonDecode(validTokenRes.body);
      if(valid == true){
        // // Now get user data, using middleware in server
        Response response = await get(
          Uri.parse('$url/'),
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': token ,
          }
        );

        // var userProvider = Provider.of<UserProvider>(context, listen: false);
        // userProvider.setUser(jsonDecode(response.body));
      }

    }on SocketException catch (_) {
      showFlutterToast(msg: 'Se ha excedido el tiempo límite de la solicitud', isSuccess: false);
    } catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
    }finally {
      client.close();
    }
  }

  // Edit user profile
  Future editUserProfile({
    required BuildContext context,
    required User user,
  })
  async{
    final client = IOClient(HttpClient()..connectionTimeout = Duration(seconds: timeoutDurationSeconds));
    try{

      Response res = await client.put(
        Uri.parse('$url/accounts/editprofile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );

      if(res.statusCode == 200)
      {
        print(jsonDecode(res.body)['user']);
        Provider.of<UserProvider>(context, listen: false).setUser(jsonDecode(res.body)['user']);
      }
      return res;
    }on SocketException catch (_) {
      showFlutterToast(msg: 'Se ha excedido el tiempo límite de la solicitud', isSuccess: false);
    }catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
    }finally {
      client.close();
    }

  }

}
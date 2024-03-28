import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_inspection_kit_app/constants/utils.dart';
import 'package:tree_inspection_kit_app/models/user.dart';
import 'package:http/http.dart';
import 'package:tree_inspection_kit_app/constants/global_variables.dart';
import 'package:tree_inspection_kit_app/models/valid_response.dart';
import 'package:tree_inspection_kit_app/providers/user_provider.dart';
import 'package:tree_inspection_kit_app/screens/login.dart';

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

        String encryptedPassword = getPasswordHash(password);

        User user = User(
          id: -1,
          name: name,
          email: email,
          token: ''
        );

        Response res = await client.post(
          Uri.parse('$url/auth/register'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "name": name,
            "email": email,
            "password": encryptedPassword

          }),
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

      String encryptedPassword = getPasswordHash(password);


      Response res = await client.post(
        Uri.parse('$url/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "email": email,
          "password" : encryptedPassword
        }),
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

      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const Login())
      );
    }catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
    }finally {
      client.close();
    }
  }

// Get user data, for init state
  Future<bool> checkToken(String token) async
  {
    final client = IOClient(HttpClient()..connectionTimeout = Duration(seconds: timeoutDurationSeconds));
    try{

      Response res = await client.post(
        Uri.parse('$url/auth/checkToken'),
        headers: <String, String>{
          'Content-Type': 'application/json;',
          'auth-token': token,
        }
      );


      return res.body == "true";

    }on SocketException catch (_) {
      showFlutterToast(msg: 'Se ha excedido el tiempo límite de la solicitud', isSuccess: false);
      return false;
    } catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
      return false;
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
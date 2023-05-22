import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/models/project.dart';
import 'package:http/http.dart' as http;
import 'package:tree_timer_app/constants/global_variables.dart';
import 'package:tree_timer_app/models/valid_response.dart';

class ProjectService{

  Future newProject({
    required BuildContext context,
    required String name,
    required String user_id,
  })
  async{
    final client = IOClient(HttpClient()..connectionTimeout = Duration(seconds: 10));
    try{
      Project project = Project(
        id: '',
        name: name,
        description: '',
        user_id: user_id
      );


      Response res = await client.post(
        Uri.parse('$url/projects/new'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: project.toJson(),
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

  Future<dynamic> getProjects(String user_id) async {
    final response = await http.get(
        Uri.parse('$url/projects/getall/$user_id'),
      );

    if (response.statusCode == 200) {
      List<dynamic> listJson = json.decode(response.body);

    return listJson;
    } else {
      throw Exception('Error al obtener la lista proyectos');
    }
  }

  Future<dynamic> getUserProject(String user_id, String project_name) async {
    try
    {
      final response = await http.get(
        Uri.parse('$url/projects/getUserProject/$user_id?project_name=$project_name'),
      );

      if (ValidResponse(response).isSuccess) {
        List<dynamic> listJson = json.decode(response.body);
        showFlutterToast(msg: "Abriendo proyecto...", isSuccess: true);
        return listJson[0];
      }else{
        showFlutterToast(msg: 'Error al obtener proyecto', isSuccess: false);
      }
    }
    catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
    } 
  }

  Future deleteProject({required BuildContext context, required String id}) async {
    try
    {
      final response = await http.delete(
        Uri.parse('$url/projects/delete/${id}'),
      );

      if (ValidResponse(response).isSuccess) {
        dynamic listJson = json.decode(response.body);
        showFlutterToast(msg: "¡Proyecto borrado correctamente!", isSuccess: true);
        return listJson;
      }else{
        showFlutterToast(msg: 'Error al intentar borrar proyecto', isSuccess: false);
      }
    }
    catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
    } 
  }

  Future editProject({required BuildContext context, required Project project}) async {
    try
    {

      final res = await http.put(
        Uri.parse('$url/projects/edit'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: project.toJson(),
      );

      return ValidResponse(res);
      
    }
    catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
    } 
  }

  Future exportProject({required BuildContext context, required Project project}) async
  {
    try
    {

      final res = await http.get(
        Uri.parse('$url/projects/export/${project.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return res;
      
    }
    catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
    }
  }
  
}
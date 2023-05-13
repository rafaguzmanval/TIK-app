import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:tree_timer_app/constants/error_handling.dart';
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
      showSnackBar(context, 'Se ha excedido el tiempo límite de la solicitud');
    }catch(err){
      showSnackBar(context, err.toString());
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

  Future deleteProject({required BuildContext context, required String id}) async {
    try
    {
      final response = await http.delete(
        Uri.parse('$url/projects/delete/${id}'),
      );

      httpErrorHandler(res: response, context: context,
        onSuccess: (){
          showSnackBar(context, "¡Proyecto borrado correctamente!");
        }
      );
      
    }
    catch(err){
      showSnackBar(context, err.toString());
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

      return ValidResponse.fromResponse(res, res.body);
      
    }
    catch(err){
      showSnackBar(context, err.toString());
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
      showSnackBar(context, err.toString());
    }
  }
  
}
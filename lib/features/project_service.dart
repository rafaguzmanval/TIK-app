import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tree_timer_app/constants/error_handling.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/models/project.dart';
import 'package:http/http.dart' as http;
import 'package:tree_timer_app/constants/global_variables.dart';

class ProjectService{

  void newProject({
    required BuildContext context,
    required String name,
  })
  async{

    try{
      Project project = Project(
        id: '',
        name: name,
        description: '',
        // listTreeSheetsId: []
      );


      http.Response res = await http.post(
        Uri.parse('$url/projects/new'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: project.toJson(),
      );

      httpErrorHandler(res: res, context: context,
        onSuccess: (){
          showSnackBar(context, "¡Nuevo proyecto creado correctamente!");
        }
      );
    } catch(err){
      showSnackBar(context, err.toString());
    }
  }

  Future<dynamic> getProjects() async {
    final response = await http.get(
        Uri.parse('$url/projects/getall'),
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
  
}
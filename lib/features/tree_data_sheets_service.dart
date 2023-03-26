import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tree_timer_app/constants/error_handling.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/models/tree_data_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:tree_timer_app/constants/global_variables.dart';
import 'package:tree_timer_app/models/tree_specie.dart';

class TreeDataSheetService{

  void newTreeDataSheet({
    required BuildContext context,
    required String project_id,
    required TreeSpecie treeSpecie,
    required String treeId,
    String? description
  })
  async{

    try{
      TreeDataSheet treeDataSheet = TreeDataSheet(
        id: '',
        project_id: project_id,
        specific_tree_id: treeId,
        tree_specie_id: treeSpecie.id,
        description: description,
      );


      http.Response res = await http.post(
        Uri.parse('$url/treedatasheets/new'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: treeDataSheet.toJson(),
      );

      httpErrorHandler(res: res, context: context,
        onSuccess: (){
          showSnackBar(context, "¡Nueva ficha de datos creada correctamente!");
        }
      );
    } catch(err){
      showSnackBar(context, err.toString());
    }
  }

  
  void updateTreeDataSheet({
    required BuildContext context,
    required String id,
    required String project_id,
    required TreeSpecie treeSpecie,
    required String treeId,
    String? description
  })
  async{

    try{
      TreeDataSheet treeDataSheet = TreeDataSheet(
        id: id,
        project_id: project_id,
        specific_tree_id: treeId,
        tree_specie_id: treeSpecie.id,
        description: description,
      );

      http.Response res = await http.put(
        Uri.parse('$url/treedatasheets/update/${treeDataSheet.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: treeDataSheet.toJson(),
      );

      httpErrorHandler(res: res, context: context,
        onSuccess: (){
          showSnackBar(context, "¡Ficha de datos actualizada correctamente!");
        }
      );
    } catch(err){
      showSnackBar(context, err.toString());
    }
  }

// Get user data, for init state
  Future<dynamic> getProjectTreeDataSheets(String projectid) async {
    final response = await http.get(
        Uri.parse('$url/treedatasheets/project/$projectid'),
      );

    if (response.statusCode == 200) {
      List<dynamic> listJson = json.decode(response.body);

    return listJson;
    } else {
      throw Exception('Error al obtener las fichas de datos del proyecto');
    }
  }

  Future<dynamic> findTreeDataSheet(String _id) async {
    final response = await http.get(
        Uri.parse('$url/treedatasheets/${_id}'),
      );

    if (response.statusCode == 200) {
      Map<String, dynamic> listJson = json.decode(response.body);

      return listJson;
    } else {
      throw Exception('Error al obtener la ficha de datos');
    }
  }

  void deleteTreeDataSheet({required BuildContext context, required String id}) async {
    try
    {
      final response = await http.delete(
        Uri.parse('$url/treedatasheets/delete/${id}'),
      );

      httpErrorHandler(res: response, context: context,
        onSuccess: (){
          showSnackBar(context, "¡Ficha de datos borrada correctamente!");
        }
      );
      
    }
    catch(err){
      showSnackBar(context, err.toString());
    } 
  }

}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tree_inspection_kit_app/constants/utils.dart';
import 'package:tree_inspection_kit_app/models/tree_data_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:tree_inspection_kit_app/constants/global_variables.dart';

class TreeDataSheetService{

  Future newTreeDataSheet({
    required BuildContext context,
    required TreeDataSheet treeDataSheet
  })
  async{

    try{

      http.Response res = await http.post(
        Uri.parse('$url/treedatasheets/new'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: treeDataSheet.toJson(),
      );

      return res;
    } catch(err){
      showFlutterToast(msg: err.toString(), isSuccess: false);
    }
  }

  
  void updateTreeDataSheet({
    required BuildContext context,
    required TreeDataSheet treeDataSheet
  })
  async{

    try{

      http.Response res = await http.put(
        Uri.parse('$url/treedatasheets/update/${treeDataSheet.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: treeDataSheet.toJson(),
      );

      showFlutterToast(msg: "¡Ficha de datos actualizada correctamente!", isSuccess: true);
    } catch(err){
      showFlutterToast(msg:  err.toString(), isSuccess: false);
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

  Future deleteTreeDataSheet({required BuildContext context, required TreeDataSheet treeDataSheet}) async {
    try
    {
      final response = await http.delete(
        Uri.parse('$url/treedatasheets/delete/${treeDataSheet.id}'),
        body: treeDataSheet.toJson(),
      );

      return response;
      
    }
    catch(err){
      showFlutterToast(msg:  err.toString(), isSuccess: false);
    } 
  }

}
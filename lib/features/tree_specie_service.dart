import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:tree_timer_app/constants/error_handling.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/models/tree_specie.dart';
import 'package:http/http.dart' as http;
import 'package:tree_timer_app/constants/global_variables.dart';
import 'package:tree_timer_app/providers/tree_specie_provider.dart';
import 'package:tree_timer_app/screens/home.dart';
import 'package:tree_timer_app/screens/login.dart';

class TreeSpecieService{

  // Register user
  void registerSpecie({
    required BuildContext context,
    required String name,
    required String description,
  })
  async{

    try{
      TreeSpecie treeSpecie = TreeSpecie(
        id: '',
        name: name,
        description: description,
      );


      http.Response res = await http.post(
        Uri.parse('$url/treespecies/new'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: treeSpecie.toJson(),
      );

      httpErrorHandler(res: res, context: context,
        onSuccess: (){
          showSnackBar(context, "¡Nueva especie creada correctamente!");
        }
      );
    } catch(err){
      showSnackBar(context, err.toString());
    }
  }

// Get user data, for init state
  // Future<List<TreeSpecie>> obtenerEspecies() async {
  Future<dynamic> obtenerEspecies() async {
    String v = url;
    final response = await http.get(
        Uri.parse('$url/treespecies/getall'),
      );

    if (response.statusCode == 200) {
      List<dynamic> listJson = json.decode(response.body);

    return listJson;
    } else {
      throw Exception('Error al obtener las especies de árboles');
    }
  }
}
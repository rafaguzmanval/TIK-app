import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/models/tree_specie.dart';
import 'package:http/http.dart' as http;
import 'package:tree_timer_app/constants/global_variables.dart';

class TreeSpecieService{

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
      
      showFlutterToast(msg: "¡Nueva especie creada correctamente!", isSuccess: true);

    } catch(err){
      showFlutterToast(msg:  err.toString(), isSuccess: false);
    }
  }

  Future<dynamic> getSpecies() async {
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

  Future<dynamic> findSpecie(String _id) async {
    final response = await http.get(
        Uri.parse('$url/treespecies/${_id}'),
      );

    if (response.statusCode == 200) {
      Map<String, dynamic> listJson = json.decode(response.body);

      return listJson;
    } else {
      throw Exception('Error al obtener la especie de árbol seleccionada');
    }
  }
}
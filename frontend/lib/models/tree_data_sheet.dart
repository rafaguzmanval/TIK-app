import 'dart:convert';

import 'package:tree_inspection_kit_app/models/measurement.dart';

// Creating user model
class TreeDataSheet{
  final String id;
  final String project_id;
  final String specie_id;
  final String? description;
  final double? latitude;
  final double? longitude;
  String? imageURL;
  List<Measurement>? measurements;


  TreeDataSheet(
    {required this.id, required this.project_id,
     required this.specie_id, this.description, this.latitude, this.longitude, this.imageURL, this.measurements}
  );

  // Create an empty TreeDataSheet constructor
  TreeDataSheet.empty({required this.project_id, this.id = '', this.specie_id = "", this.description = "", this.latitude = 0.0, this.longitude = 0.0, this.imageURL = "", this.measurements});
 

  // Create a object map
  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "project_id": project_id,
      "specie_id": specie_id,
      "description": description,
      "latitude": latitude?.toDouble(),
      "longitude": longitude?.toDouble(),
      'image': imageURL,
      'measurements': measurements,
    };
  }

  // Factory fucntion to parse from JSON to object
  factory TreeDataSheet.fromJson(Map<String, dynamic> parsedJson){
    // we have to parse the measurements list
    List<dynamic> measurementsJson = parsedJson["measurements"];
    List<Measurement> parsedMeasurements = measurementsJson.map((measurement) => Measurement.fromJson(measurement)).toList();
    return TreeDataSheet(
      id: parsedJson["id"] ?? '',
      project_id: parsedJson["project_id"],
      specie_id: parsedJson["specie_id"] ?? '',
      description: parsedJson["description"] ?? '',
      latitude: parsedJson["latitude"]?.toDouble() ?? 0,
      longitude: parsedJson["longitude"]?.toDouble()?? 0,
      imageURL: parsedJson["imageURL"] ?? '',
      measurements: parsedMeasurements,

    );
  }

  factory TreeDataSheet.parseTreeDataSheets(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TreeDataSheet>((json) => TreeDataSheet.fromJson(json)).toList();
  }

  // Create toJson method
  String toJson() => json.encode(toMap());

}


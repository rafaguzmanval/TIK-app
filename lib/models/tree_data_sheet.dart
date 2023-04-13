import 'dart:convert';

// Creating user model
class TreeDataSheet{
  final String id;
  final String project_id;
  final String specific_tree_id;
  final String tree_specie_id;
  final String? description;
  final double? latitude;
  final double? longitude;

  TreeDataSheet(
    {required this.id, required this.project_id, required this.specific_tree_id,
     required this.tree_specie_id, this.description, this.latitude, this.longitude}
  ); 

  // Create a object map
  Map<String, dynamic> toMap(){
    return {
      "_id": id,
      "project_id": project_id,
      "specific_tree_id": specific_tree_id,
      "tree_specie_id": tree_specie_id,
      "description": description,
      "latitude": latitude?.toDouble(),
      "longitude": longitude?.toDouble(),
    };
  }

  // Factory fucntion to parse from JSON to object
  factory TreeDataSheet.fromJson(Map<String, dynamic> parsedJson){
    return TreeDataSheet(
      id: parsedJson["_id"] ?? '',
      project_id: parsedJson["project_id"],
      specific_tree_id: parsedJson["specific_tree_id"] ?? '',
      tree_specie_id: parsedJson["tree_specie_id"] ?? '',
      description: parsedJson["description"] ?? '',
      latitude: parsedJson["latitude"]?.toDouble() ?? 0,
      longitude: parsedJson["longitude"]?.toDouble()?? 0,
    );
  }

  factory TreeDataSheet.parseTreeDataSheets(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TreeDataSheet>((json) => TreeDataSheet.fromJson(json)).toList();
  }

  // Create toJson method
  String toJson() => json.encode(toMap());

}


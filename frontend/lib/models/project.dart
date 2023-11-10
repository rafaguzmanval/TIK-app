import 'dart:convert';

// Creating user model
class Project{
  final String id;
  String name;
  String description;
  final String user_id;

  Project(
    {required this.name, required this.id, required this.description, required this.user_id}
  ); 

  // Create a object map
  Map<String, dynamic> toMap(){
    return {
      "_id": id,
      "name": name,
      "description": description,
      "user_id": user_id,
    };
  }

  // Factory fucntion to parse from JSON to object
  factory Project.fromJson(Map<String, dynamic> parsedJson){
    return Project(
      id: parsedJson["_id"] ?? '',
      name: parsedJson["name"],
      description: parsedJson["description"] ?? '',
      user_id: parsedJson["user_id"],
    );
  }

  factory Project.parseProjects(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Project>((json) => Project.fromJson(json)).toList();
  }

  // Create toJson method
  String toJson() => json.encode(toMap());

}


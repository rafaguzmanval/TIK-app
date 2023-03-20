import 'dart:convert';

// Creating user model
class TreeSpecie{
  final String id;
  final String name;
  final String description;

  TreeSpecie(
    {required this.name, required this.id, required this.description}
  ); 

  // Create a object map
  Map<String, dynamic> toMap(){
    return {
      "_id": id,
      "name": name,
      "description": description,
    };
  }

  // Factory function to parse from JSON to object
  factory TreeSpecie.fromJson(Map<String, dynamic> parsedJson){
    return TreeSpecie(
      id: parsedJson["_id"] ?? '',
      name: parsedJson["name"],
      description: parsedJson["description"] ?? '',
    );
  }

  factory TreeSpecie.parseTreeSpecies(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TreeSpecie>((json) => TreeSpecie.fromJson(json)).toList();
  }

  // Create toJson method
  String toJson() => json.encode(toMap());

}


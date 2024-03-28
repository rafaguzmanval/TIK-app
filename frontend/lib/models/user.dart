import 'dart:convert';

// Creating user model
class User{
  final int id;
  final String name;
  final String email;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token
  }); 

  // Create a object map
  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "name": name,
      "email": email,
      "token": token
    };
  }

  // Factory fucntion to parse from JSON to object
  factory User.fromJson(Map<String, dynamic> parsedJson){
    return User(
      id : parsedJson["id"],
      name: parsedJson["name"],
      email: parsedJson["email"],
      token: parsedJson["token"] ?? '',
    );
  }

  // Create toJson method
  String toJson() => json.encode(toMap());

}


import 'dart:convert';

// Creating user model
class User{
  final String id;
  final String name;
  final String email;
  final String password;
  final String confirmpassword;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmpassword,
    required this.token
  }); 

  // Create a object map
  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "confirmpassword": confirmpassword,
      "token": token
    };
  }

  // Factory fucntion to parse from JSON to object
  factory User.fromJson(Map<String, dynamic> parsedJson){
    return User(
      id: parsedJson["_id"],
      name: parsedJson["name"],
      email: parsedJson["email"],
      password: parsedJson["password"],
      confirmpassword: parsedJson["confirmpassword"] != null && parsedJson["confirmpassword"].isNotEmpty
      ? parsedJson["confirmpassword"]
      : '',
      token: parsedJson["token"] ?? '',
    );
  }

  // Create toJson method
  String toJson() => json.encode(toMap());

}


import 'dart:convert';

// Create a measurement class
class Measurement{
  double? distance;
  double? time;
  double? avgVelocity;

  Measurement({ this.distance, this.time, this.avgVelocity});

  // Create a object map
  Map<String, dynamic> toMap(){
    return {
      "distance": distance,
      "time": time,
      "avgVelocity": avgVelocity?.toDouble(),
    };
  }

  // Factory fucntion to parse from JSON to object
  factory Measurement.fromJson(Map<String, dynamic> parsedJson){
    return Measurement(
      distance: double.parse(parsedJson["distance"].toString()),
      time: double.parse(parsedJson["time"].toString()),
      avgVelocity: double.parse(parsedJson["avgVelocity"].toString()),
    );
  }

  // Create toJson method
  String toJson() => json.encode(toMap()); 

}
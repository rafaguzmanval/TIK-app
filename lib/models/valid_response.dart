// Class to check if a http response it is valid, and return msg too
import 'dart:convert';

import 'package:http/http.dart' as http;

class ValidResponse{
  bool isSuccess = false;
  late http.Response response;
  String responseMsg = '';

  // Public constructor
  ValidResponse(http.Response res){
    response = res;
    if(response.statusCode == 200){
      isSuccess = true;
    }else{
      isSuccess = false;
    }
    responseMsg = _returnResponseMessage();
  }

  String _returnResponseMessage()
  {
    String ret = '';
    dynamic jsonResponse = jsonDecode(response.body);

    if (jsonResponse is List<dynamic> && jsonResponse.isNotEmpty) {
      // Handle as a List<dynamic>
      if (jsonResponse[0].containsKey('msg') && jsonResponse[0]['msg'] != null) {
        ret = jsonResponse[0]['msg'];
      }
      if (jsonResponse[0].containsKey('error') && jsonResponse[0]['error'] != null) {
        ret = jsonResponse[0]['error'];
      }
    } else if (jsonResponse is Map<String, dynamic>) {
      // Handle as a map<String, dynamic>
      if (jsonResponse.containsKey('msg') && jsonResponse['msg'] != null) {
        ret = jsonResponse['msg'];
      }
      if (jsonResponse.containsKey('error') && jsonResponse['error'] != null) {
        ret = jsonResponse['error'];
      }
    }
    return ret;
  }
}



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
    if(jsonResponse["msg"] != null)
    {
      ret = jsonResponse["msg"];
    }
    if(jsonResponse["error"] != null)
    {
      ret = jsonResponse["error"];
    }

    return ret;
  }
}



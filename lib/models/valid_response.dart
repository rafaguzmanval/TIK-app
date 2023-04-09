// Class to check if a http response it is valid, if not, return msg too
import 'package:http/http.dart' as http;

class ValidResponse{
  final bool isSuccess;
  final dynamic body;

  // Public constructor
  ValidResponse({required this.isSuccess, this.body});
  // Private constructor
  ValidResponse._({required this.isSuccess, this.body});

  factory ValidResponse.fromResponse(http.Response res, String string){
    if(res.statusCode == 200){
      return ValidResponse._(isSuccess: true, body: res.body);
    }else{
      return ValidResponse._(isSuccess: false, body: res.body);

    }
  }
}
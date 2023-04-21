import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/models/valid_response.dart';

void httpErrorHandler({
  required http.Response res,
  required BuildContext context,
  required VoidCallback onSuccess,
}){
  switch(res.statusCode){
    case 200:
      onSuccess();
      break;

    case 400:
    case 409:
      showSnackBar(context, jsonDecode(res.body)['msg']);
      break;

    case 500:
      showSnackBar(context, jsonDecode(res.body)['error']);
      break;

    default:
      showSnackBar(context, res.body);
      break;
  }
}

void showResponseMsg(BuildContext context, Response? res){
  if(res != null){
    ValidResponse? validResponse = ValidResponse.fromResponse(res, res.body);
    httpErrorHandler(res: res, context: context,
      onSuccess: (){
        showSnackBar(context, returnResponseMessage(validResponse));
      });
  }
}
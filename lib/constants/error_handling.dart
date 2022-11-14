import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tree_timer_app/constants/utils.dart';

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
import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:http/http.dart";
import "package:tree_timer_app/models/valid_response.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool compareStr(String text1, String Text2){
  return text1 == Text2 ? true : false;
}

Future<bool?> showConfirmDialog(BuildContext context, String title, String content) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.accept),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}

String? mandatoryField(value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

// Function to return a File with the path and base64 content
File base64ToFile(String path, String base64String) {
  Uint8List bytes = base64Decode(base64String);
  File ret = File(path);
  ret.writeAsBytesSync(bytes);
  return ret;
}

// Class to manage the arrow scrolls of the lists
class ScrollControllerUtils {
  static void scrollListener(ScrollController scrollController, ValueNotifier<bool> arrowDownWardNotifier) {
    if (scrollController.position.pixels == scrollController.position.minScrollExtent) {
      arrowDownWardNotifier.value = true;
    }
    if(scrollController.position.pixels > scrollController.position.minScrollExtent && scrollController.position.pixels < scrollController.position.maxScrollExtent){
      arrowDownWardNotifier.value = false;
    }
  }
}

void showFlutterToast({required String msg, required bool isSuccess})
{
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: isSuccess ? Colors.lightGreen : Colors.red,
    textColor: Colors.white,
    fontSize: 16.0
  );
}

void showFlutterToastFromResponse({required Response res})
{
  ValidResponse validResponse = ValidResponse(res);

  Fluttertoast.showToast(
    msg: validResponse.responseMsg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: validResponse.isSuccess ? Colors.lightGreen : Colors.red,
    textColor: Colors.white,
    fontSize: 16.0
  );
}

Map<String, String> getLanguagesMap(BuildContext context)
{
  Map<String, String> languageNames = {
    AppLocalizations.of(context)!.spanish: 'es',
    AppLocalizations.of(context)!.english: 'en',
  };
  
  return languageNames;
}

Map<String, String> getLanguagesCodeMap(BuildContext context)
{
  Map<String, String> languageNames = {
    'es': AppLocalizations.of(context)!.spanish ,
    'en': AppLocalizations.of(context)!.english,
  };
  
  return languageNames;
}

String? getLanguageCode(BuildContext context, String language){
  Map<String, String> languageNames = getLanguagesMap(context);
  if(languageNames.containsKey(language))
  {
    return languageNames[language];
  }
}

String? getLanguageStr(BuildContext context, String languageCode){
  Map<String, String> languageCodes = getLanguagesCodeMap(context);
  if(languageCodes.containsKey(languageCode))
  {
    return languageCodes[languageCode];
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/project_service.dart';
import 'package:tree_timer_app/models/valid_response.dart';
import 'package:tree_timer_app/providers/user_provider.dart';

class NewProjectCustomAlertDialog extends StatefulWidget
{
  final String title;
  String hintText = DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now()).toString();

  NewProjectCustomAlertDialog({
    Key? key,
    required this.title,
  }) : super(key:key);

  @override
  State<NewProjectCustomAlertDialog> createState() => _NewProjectCustomAlertDialogState();
}

class _NewProjectCustomAlertDialogState extends State<NewProjectCustomAlertDialog> {
  
  final ProjectService projectService = ProjectService();
  final _textController = TextEditingController();

  @override
  void initState(){
   
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(widget.title),
      content: TextFormField(
        controller: _textController,
        decoration: InputDecoration(hintText: widget.hintText),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancelar")
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // if project name empty -> hintText as value
                      if(_textController.value == TextEditingValue.empty)
                      {
                        _textController.value = TextEditingValue(text: widget.hintText);
                      }

                      Response? res = await projectService.newProject(
                        context: context,
                        name: _textController.text,
                        user_id:  Provider.of<UserProvider>(context, listen: false).user.id
                      );

                      if(res != null){
                        showFlutterToastFromResponse(res: res);
                      }
                      
                      Navigator.of(context).pop();
                    },
                    child: Text("Crear")
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
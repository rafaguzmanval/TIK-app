import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tree_timer_app/features/new_project_service.dart';

class NewProjectCustomAlertDialog extends StatefulWidget
{
  final String title;
  String? hintText = DateFormat('yyyy_MM_dd').format(DateTime.now()).toString();

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
        TextButton(
          child: const Text('Crear'),
          onPressed: () {
            projectService.newProject(context: context, name: _textController.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
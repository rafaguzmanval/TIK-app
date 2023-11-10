import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tree_inspection_kit_app/constants/utils.dart';
import 'package:tree_inspection_kit_app/features/project_service.dart';
import 'package:tree_inspection_kit_app/models/project.dart';
import 'package:tree_inspection_kit_app/models/valid_response.dart';
import 'package:tree_inspection_kit_app/providers/user_provider.dart';
import 'package:tree_inspection_kit_app/screens/project.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    child: Text(AppLocalizations.of(context)!.exit)
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

                        if(ValidResponse(res).isSuccess)
                        {
                          // Exist from dialog
                          // Push to new project
                          Project createdProject = Project.fromJson(await ProjectService().getUserProject(Provider.of<UserProvider>(context, listen: false).user.id, _textController.text));
                          await Navigator.push(
                              context,
                              MaterialPageRoute(              
                                builder: (context) => ProjectScreen(project: createdProject),
                              ),
                          );
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.create)
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
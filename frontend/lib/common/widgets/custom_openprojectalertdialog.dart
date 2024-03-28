import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_arrow_downward_list_scroll.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_arrow_upward_list_scroll.dart';
import 'package:tree_inspection_kit_app/features/project_service.dart';
import 'package:tree_inspection_kit_app/models/project.dart';
import 'package:tree_inspection_kit_app/providers/user_provider.dart';
import 'package:tree_inspection_kit_app/screens/project.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/utils.dart';

class OpenProjectCustomAlertDialog extends StatefulWidget
{
  final String title;
  final bool isExport;

  OpenProjectCustomAlertDialog({
    Key? key,
    required this.title,
    required this.isExport,
  }) : super(key:key);

  @override
  State<OpenProjectCustomAlertDialog> createState() => _OpenProjectCustomAlertDialog();
}

class _OpenProjectCustomAlertDialog extends State<OpenProjectCustomAlertDialog> {
  
  final ProjectService projectService = ProjectService();
  final ScrollController scrollController = ScrollController();
  bool arrowDownWard = true;
  final arrowDownWardNotifier = ValueNotifier<bool>(true);

  void onTapProjectScreen (Project project) async {
    await Navigator.push(
        context,
        MaterialPageRoute(              
          builder: (context) => ProjectScreen(project: project),
        ),
    );
    // Rebuild widget
    setState(() {});
  }

  void onTapProjectExport(Project project) async {
    try {
      // Call to projectService to retrieve excel file
      Response res = await projectService.exportProject(context: context, project: project);
      if(res.statusCode == HttpStatus.ok)
      {
         // Get app documents directory
        final documentsDirectory = await getApplicationDocumentsDirectory();
        // Create file with project name
        var file = await File('${documentsDirectory!.path}/${res.headers['filename']}').create();
        // Write data into file
        await file.writeAsBytes(res.bodyBytes);
        // Share file
        Share.shareXFiles([XFile('${file.path}')],
            subject: '${AppLocalizations.of(context)!.emailSubjectExport}: ${project.name}', text: AppLocalizations.of(context)!.successfulExport);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.errorExport}: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  void initState(){
    scrollController.addListener((){
      ScrollControllerUtils.scrollListener(scrollController, arrowDownWardNotifier);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(widget.title),
      content:  Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0, // Ancho del borde personalizado
          ),
          borderRadius: BorderRadius.circular(5.0), // Borde redondeado personalizado
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: projectService.getProjects(Provider.of<UserProvider>(context, listen: false).user.id),
                    builder: (context, snapshot) {
                      if(snapshot.hasData)
                      {
                        return Column(
                          children: [
                            Container(
                              // We must to set height and width in order to prevent errors
                              // with listView dimensions
                              width: 400,
                              height: 450,
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(Icons.book, color: Colors.green,),
                                    title: Text(snapshot.data[index]["name"]),
                                    onTap: () async{
                                      Project project = Project(
                                          id: snapshot.data[index]["id"].toString(),
                                          name: snapshot.data[index]["name"],
                                          description: snapshot.data[index]["description"] ?? '',
                                          user_id:  Provider.of<UserProvider>(context, listen: false).user.id,
                                      );

                                      // Si no estamos exportando datos, abrimos página de proyecto
                                      if(!widget.isExport)
                                      {
                                        onTapProjectScreen(project);
                                      }
                                      else
                                      {
                                        onTapProjectExport(project);
                                      }
                                    },
                                  );
                                },
                              ), 
                            ),
                            // Show scroll arrow if number of elements > 8
                            snapshot.data.length > 5
                            ? ValueListenableBuilder<bool>(
                              valueListenable: arrowDownWardNotifier,
                              builder: (context, arrowDownWard, child) {
                                return arrowDownWard 
                                  ? ArrowDownWardListScroll(scrollController: scrollController) 
                                  : ArrowUpWardListScroll(scrollController: scrollController);
                              },
                            )
                            : SizedBox(),
                          ]
                        );
                      }
                      else if(snapshot.hasError){
                        showFlutterToast(msg: snapshot.error.toString(), isSuccess: false);
                      }
                      return CircularProgressIndicator();
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.exit)
        )
      ],
    );
  }
}


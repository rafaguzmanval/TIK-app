// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_arrow_downward_list_scroll.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_arrow_upward_list_scroll.dart';
import 'package:tree_inspection_kit_app/common/widgets/custom_floating_buttons_bottom.dart';
import 'package:tree_inspection_kit_app/constants/utils.dart';
import 'package:tree_inspection_kit_app/features/project_service.dart';
import 'package:tree_inspection_kit_app/features/tree_data_sheets_service.dart';
import 'package:tree_inspection_kit_app/models/project.dart';
import 'package:tree_inspection_kit_app/models/tree_data_sheet.dart';
import 'package:tree_inspection_kit_app/models/valid_response.dart';
import 'package:tree_inspection_kit_app/screens/tree_data_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectScreen extends StatefulWidget {

  Project project;

  ProjectScreen({
    Key? key,
    required this.project,
  }) : super(key:key);

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {

  // Services variables
  TreeDataSheetService treeDataSheetService = new TreeDataSheetService();
  ProjectService projectService = new ProjectService();

  // Booleans variables
  bool isEditing = false;
  bool arrowDownWard = true;
  bool loading = true;

  // GlobalKey variable
  final _editFormKey = GlobalKey<FormState>();

  // TextEditingController variables
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  // ScrollController varibale
  final ScrollController scrollController = ScrollController();

  // ValueNotifier variable
  final arrowDownWardNotifier = ValueNotifier<bool>(true);

  // Function which is executed when a project is going to be deleted
  void onDeleted() async {
      bool? deleteProject = await showConfirmDialog(context, AppLocalizations.of(context)!.deleteProject, AppLocalizations.of(context)!.warningDeleteProject);
      if(deleteProject == true && widget.project != null){
        await projectService.deleteProject(context: context, id: widget.project.id);
        Navigator.pop(context);
      }else{
        return null;
      }
    }

  // Function which is executed when a project is going to be updated
  void onUpdated () async {
    if(isEditing == true){
      if(_editFormKey.currentState!.validate()) {
        bool? updateProject = await showConfirmDialog(context, AppLocalizations.of(context)!.updateProject,"");
        if(updateProject == true){
          ValidResponse? validRes = await projectService.editProject(context: context, project: Project(name: titleController.text, id: widget.project.id, description: descriptionController.text, user_id: widget.project.user_id));
          if(validRes?.isSuccess == true){
            setState(() {
              isEditing = false;
              widget.project.name = titleController.text;
              widget.project.description = descriptionController.text;
            });
            showFlutterToast(msg: validRes!.responseMsg, isSuccess: validRes.isSuccess);
          }
        }
      }
    }else{
      setState(() {
        isEditing = true;
      });
    }
  }

  void onPressedLeading(){
    if(!isEditing)
    {
      Navigator.pop(context);
    }
    else{
      setState(() {
        isEditing = false;
      });
    }
  } 

  @override
  void initState(){
    super.initState();
    // Add scroll listener
    scrollController.addListener(() {
      ScrollControllerUtils.scrollListener(scrollController, arrowDownWardNotifier);
    });
    // Set text controllers values
    titleController.text = widget.project.name.toString();
    descriptionController.text = widget.project.description.toString();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: isEditing ? Icon(Icons.close) : Icon(Icons.arrow_back),
          onPressed: onPressedLeading,
        ),
        title: isEditing ? Form(
          key: _editFormKey,
          child: TextFormField(
            controller: titleController,
            validator: mandatoryField,
            maxLines: 1,
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                ),
              ),
              hintText: AppLocalizations.of(context)!.projectName,
            ),
          )) : Text(widget.project.name),
      ),
      body: Stack(
        children: [
          Container(
            // Set all the display height
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              // Establish some space between available data sheets and floating buttons
              padding: EdgeInsets.only(bottom: 60),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 30.0,),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.description,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
                          child: isEditing ? TextFormField(
                              controller: descriptionController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: AppLocalizations.of(context)!.description,
                              )) : Align(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.project.description.toString())
                              ),
                        ),
                      ] 
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Text(
                      AppLocalizations.of(context)!.availablesDataSheets,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),      
                  SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30), //border corner radius
                        boxShadow:[ 
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5), //color of shadow
                              spreadRadius: 5, //spread radius
                              blurRadius: 7, // blur radius
                              offset: Offset(0, 2), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.all(30),
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // List data sheets of a project
                          FutureBuilder(
                            future: treeDataSheetService.getProjectTreeDataSheets(widget.project.id),
                            builder: (context, snapshot) {

                                // Show circular progress while no info is received

                              // If we have data from tree data sheets
                              if(snapshot.hasData)
                              {
                                  loading = false;
                                  return Column(
                                    children: [
                                      Container(
                                        // We must to set height and width in order to prevent errors
                                        // with listView dimensions
                                        width: 400,
                                        height: 300,
                                        child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              contentPadding: EdgeInsets.fromLTRB(40, 0, 40, 5),
                                              leading: Icon(Icons.energy_savings_leaf, color: Colors.green,),
                                              title: Text(snapshot.data[index]["id"].toString()),
                                              onTap: () async {
                                                // Get temp directory to show data sheet image (if exists) on tree data sheet screen
                                                Directory tmpDir = await getTemporaryDirectory();
                                                /*await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => TreeDataSheetScreen(
                                                      treeDataSheet: TreeDataSheet.fromJson(snapshot.data[index]),
                                                      project: widget.project,
                                                      tmpDir: tmpDir,
                                                    ),
                                                  ),
                                                );*/
                                                // Rebuild widget
                                                setState(() {
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      // If there are more than 5 elements then show arrows to scroll up and down
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
                                  print(snapshot.error.toString());
                                  showFlutterToast(msg: snapshot.error.toString(), isSuccess: false);
                                }
                                else if(loading)
                                {
                                  return CircularProgressIndicator();
                                }

                              return Container();

                            }
                          ),
                          SizedBox(height: 15,),
                          FloatingActionButton(
                            // To avoid conflicts with same tags between floating buttons
                            heroTag: UniqueKey(),
                            onPressed: () async {
                              // Get temp directory
                              Directory tmpDir = await getTemporaryDirectory();
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(              
                                    builder: (context) => TreeDataSheetScreen(project: widget.project, treeDataSheet: TreeDataSheet.empty(project_id: widget.project.id), tmpDir: tmpDir,),
                                  ),
                              );
                              // Rebuild widget
                              setState(() {
                                
                              });
                            },
                            tooltip: AppLocalizations.of(context)!.createNewDataSheet,
                            child: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    )
                  ),
                ]
              ),
            ),
          ),
        ],
      ),
      // Create floating buttons at the screen bottom
      floatingActionButton: CustomFloatingButtonsBottom(parentWidget: widget, onSaved: onUpdated, onDeleted: onDeleted, isEditing: isEditing,),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
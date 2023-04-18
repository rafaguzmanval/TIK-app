import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tree_timer_app/common/widgets/custom_floating_buttons_bottom.dart';
import 'package:tree_timer_app/constants/error_handling.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/project_service.dart';
import 'package:tree_timer_app/features/tree_data_sheets_service.dart';
import 'package:tree_timer_app/features/tree_specie_service.dart';
import 'package:tree_timer_app/models/project.dart';
import 'package:tree_timer_app/models/tree_data_sheet.dart';
import 'package:tree_timer_app/models/tree_specie.dart';
import 'package:tree_timer_app/models/valid_response.dart';
import 'package:tree_timer_app/screens/tree_data_sheet.dart';

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

  TreeDataSheetService treeDataSheetService = new TreeDataSheetService();
  ProjectService       projectService       = new ProjectService();
  bool                 isEditing            = false;
  final _editFormKey = GlobalKey<FormState>();
  final TextEditingController descriptionController =  TextEditingController();
  final TextEditingController titleController =  TextEditingController();

void onDeleted() async {
    bool? deleteProject = await showConfirmDialog(context, "¿Desea borrar el proyecto?", "Borrará todas las fichas de datos asociadas al proyecto");
    if(deleteProject == true && widget.project != null){
      await projectService.deleteProject(context: context, id: widget.project.id);
      Navigator.pop(context);
    }else{
      return null;
    }
  }

  void onSaved () async {
    // If user is editing then change use this function
    if(isEditing == true){
      if(_editFormKey.currentState!.validate()) {
        bool? deleteProject = await showConfirmDialog(context, "¿Desea actualizar el proyecto?","");
        if(deleteProject == true){
          ValidResponse? validRes = await projectService.editProject(context: context, project: Project(name: titleController.text, id: widget.project.id, description: descriptionController.text, user_id: widget.project.user_id));
          if(validRes?.isSuccess == true){
            setState(() {
              isEditing = false;
              widget.project.name = titleController.text;
              widget.project.description = descriptionController.text;
            });
            showSnackBar(context, jsonDecode(validRes?.body)['msg']);
          }
        }
      }
    }else{
      setState(() {
        isEditing = true;
      });
    }
  }  

  @override
  void initState(){
    super.initState();
    titleController.text = widget.project.name.toString();
    descriptionController.text = widget.project.description.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEditing ? Form(
          key: _editFormKey,
          child: TextFormField(
            controller: titleController,
            validator: mandatoryField,
            maxLines: 1,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: 'Nombre proyecto',
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
                        const Text(
                          "Descripción",
                          style: TextStyle(
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
                                hintText: 'Descripción',
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
                    child: const Text(
                      "Fichas disponibles",
                      style: TextStyle(
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
                          //you can set more BoxShadow() here
                          ],
                      ),
                      margin: const EdgeInsets.all(30),
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder(
                            future: treeDataSheetService.getProjectTreeDataSheets(widget.project.id),
                            builder: (context, snapshot) {
                              // If we have data from tree data sheets
                              if(snapshot.hasData)
                              {
                                return Column(
                                  children: [
                                    Container(
                                      // We must to set height and width in order to prevent errors
                                      // with listView dimensions
                                      width: 400,
                                      height: 300,
                                      child: ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            contentPadding: EdgeInsets.fromLTRB(40, 0, 40, 5),
                                            leading: Icon(Icons.energy_savings_leaf, color: Colors.green,),
                                            title: Text(snapshot.data[index]["specific_tree_id"].toString()),
                                            onTap: () async {
                                              // Get temp directory
                                              Directory tmpDir = await getTemporaryDirectory();
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(              
                                                  builder: (context) => TreeDataSheetScreen(
                                                    treeDataSheet: TreeDataSheet.fromJson(snapshot.data[index]),
                                                    project: widget.project,
                                                    tmpDir: tmpDir,
                                                  ),
                                                ),
                                              );
                                              // Rebuild widget
                                              setState(() {
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ]
                                );
                              }
                              else if(snapshot.hasError){
                                showSnackBar(context, snapshot.error.toString());
                              }
                              return CircularProgressIndicator();
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
                                    builder: (context) => TreeDataSheetScreen(project: widget.project, treeDataSheet: null, tmpDir: tmpDir,),
                                  ),
                              );
                              // Rebuild widget
                              setState(() {
                                
                              });
                            },
                            tooltip: 'Crear nueva ficha de datos',
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
      floatingActionButton: CustomFloatingButtonsBottom(parentWidget: widget, onSaved: onSaved, onDeleted: onDeleted, isEditing: isEditing,),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
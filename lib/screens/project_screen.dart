import 'package:flutter/material.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/project_service.dart';
import 'package:tree_timer_app/features/tree_data_sheets_service.dart';
import 'package:tree_timer_app/features/tree_specie_service.dart';
import 'package:tree_timer_app/models/project.dart';
import 'package:tree_timer_app/models/tree_data_sheet.dart';
import 'package:tree_timer_app/models/tree_specie.dart';
import 'package:tree_timer_app/screens/tree_data_sheet.dart';

class ProjectScreen extends StatefulWidget {

  final Project project;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    Text(
                      "Descripción",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15.0, left: 25.0),
                      child: Align(
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
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
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
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(              
                                              builder: (context) => TreeDataSheetScreen(
                                                treeDataSheet: TreeDataSheet.fromJson(snapshot.data[index]),
                                                project: widget.project,
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
                        heroTag: UniqueKey(),
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(              
                                builder: (context) => TreeDataSheetScreen(project: widget.project, treeDataSheet: null),
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: () async {
          bool? deleteProject = await showConfirmDialog(context, "¿Desea borrar el proyecto?", "Borrará todas las fichas de datos asociadas al proyecto");
          if(deleteProject == true && widget.project != null){
            await projectService.deleteProject(context: context, id: widget.project.id);
            Navigator.pop(context);
          }else{
            return null;
          }
        },
        tooltip: 'Borrar proyecto',
        child: const Icon(Icons.delete),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
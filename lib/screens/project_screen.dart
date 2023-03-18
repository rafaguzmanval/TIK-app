import 'package:flutter/material.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/tree_data_sheets_service.dart';
import 'package:tree_timer_app/models/project.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                  margin: const EdgeInsets.all(30),
                  child: Center(
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
                                    height: 450,
                                    child: ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: Icon(Icons.energy_savings_leaf, color: Colors.green,),
                                          title: Text(snapshot.data[index]["specific_tree_id"].toString()),
                                          onTap: () {
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(              
                builder: (context) => TreeDataSheet(project: widget.project),
              ),
          );
        },
        tooltip: 'Crear nueva ficha de datos',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
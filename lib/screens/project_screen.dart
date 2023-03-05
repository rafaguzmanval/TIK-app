import 'package:flutter/material.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/project_service.dart';


class ProjectScreen extends StatefulWidget {

  final String projectName;

  ProjectScreen({
    Key? key,
    required this.projectName,
  }) : super(key:key);

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {

  ProjectService projectService = new ProjectService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName),
      ),
      body: Container(
        child: Column(
          children: [
            Text("Fichas disponibles:"),
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(30),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: projectService.getProjects(),
                        builder: (context, snapshot) {
                          // If we have data from tree species
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
                                        leading: Icon(Icons.book, color: Colors.green,),
                                        title: Text(snapshot.data[index]["name"]),
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
        }),
        tooltip: 'Crear nueva ficha de datos',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
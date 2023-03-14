import 'package:flutter/material.dart';
import 'package:tree_timer_app/features/project_service.dart';
import 'package:tree_timer_app/models/project.dart';
  import 'package:tree_timer_app/screens/project_screen.dart';
import '../../constants/utils.dart';

class OpenProjectCustomAlertDialog extends StatefulWidget
{
  final String title = "Seleccione el proyecto";

  OpenProjectCustomAlertDialog({
    Key? key,
  }) : super(key:key);

  @override
  State<OpenProjectCustomAlertDialog> createState() => _OpenProjectCustomAlertDialog();
}

class _OpenProjectCustomAlertDialog extends State<OpenProjectCustomAlertDialog> {
  
  final ProjectService projectService = ProjectService();

  @override
  void initState(){
   
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(widget.title),
      content:  SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: projectService.getProjects(),
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
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Icon(Icons.book, color: Colors.green,),
                                  title: Text(snapshot.data[index]["name"]),
                                  onTap: () {
                                    Project project = Project(
                                        id: snapshot.data[index]["_id"],
                                        name: snapshot.data[index]["name"],
                                        description: snapshot.data[index]["description"] ?? '',
                                        listTreeSheetsId: snapshot.data[index]["listTreeSheetsId"] ?? []
                                    );
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(              
                                          builder: (context) => ProjectScreen(project: project),
                                        ),
                                    );
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
      actions: <Widget>[
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text("Salir")
        )
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/tree_specie_service.dart';
import 'package:tree_timer_app/models/tree_specie.dart';

class CustomAlertDialogTreeSpecies extends StatelessWidget {
  final String title = "Especies de arboles";
  TreeSpecieService treeSpecieService = new TreeSpecieService();

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text(this.title),
      content:  SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: treeSpecieService.getSpecies(),
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
                                  onTap: (){
                                    TreeSpecie treeSpecie = TreeSpecie(
                                      name: snapshot.data[index]["name"],
                                      id: snapshot.data[index]["_id"],
                                      description: snapshot.data[index]["description"] ?? ''
                                    );
                                    
                                    Navigator.pop(context, treeSpecie);
                                  }
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
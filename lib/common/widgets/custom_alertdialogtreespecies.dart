import 'package:flutter/material.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/tree_specie_service.dart';
import 'package:tree_timer_app/models/tree_specie.dart';

class CustomAlertDialogTreeSpecies extends StatefulWidget {
  final String title = "Especies de arboles";
  

  CustomAlertDialogTreeSpecies({super.key});
  
  @override
  State<CustomAlertDialogTreeSpecies> createState() => _CustomAlertDialogTreeSpecies();


}

class _CustomAlertDialogTreeSpecies extends State<CustomAlertDialogTreeSpecies>
{
  TreeSpecieService treeSpecieService = new TreeSpecieService();
  TextEditingController searchController = new TextEditingController();
  List<dynamic> filteredSpecies = new List.empty();
  List<dynamic> origSpeciesList = new List.empty();
  
  
  Future<void> _refreshList() async {
    // Aquí puedes actualizar la lista de items desde una fuente externa, como una API o una base de datos.
    setState(() {
      // filteredSpecies?.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text(widget.title),
      content: Container(
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
                    origSpeciesList = snapshot.data;
                    if(filteredSpecies.isEmpty == true)
                    {
                      filteredSpecies = snapshot.data;
                    }
                    return Column(
                      children: [
                        TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: 'Buscar...',
                          ),
                          // Filter tree species while introducing letters
                          onChanged: (value) {
                            // Using lowercase to find if contained word exists regardless if its cap o lower
                            filteredSpecies = origSpeciesList.where((element) => element["name"].toString().toLowerCase().contains(value.toLowerCase())).toList();
                            // Refresh list with setState()
                            this.setState(() {});
                          },
                        ),
                        SingleChildScrollView(
                          child: Container(
                            // We must to set height and width in order to prevent errors
                            // with listView dimensions
                            width: 400,
                            height: 450,
                            child: RefreshIndicator(
                              onRefresh: _refreshList,
                              child: ListView.builder(
                                // itemCount: snapshot.data.length,
                                itemCount: filteredSpecies.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(Icons.book, color: Colors.green,),
                                    // title: Text(snapshot.data[index]["name"]),
                                    title: Text(filteredSpecies[index]["name"]),
                                    onTap: (){
                                      TreeSpecie treeSpecie = TreeSpecie(
                                        // name: snapshot.data[index]["name"],
                                        // id: snapshot.data[index]["_id"],
                                        // description: snapshot.data[index]["description"] ?? ''
                                        name: filteredSpecies[index]["name"],
                                        id: filteredSpecies[index]["_id"],
                                        description: filteredSpecies[index]["description"] ?? ''
                                      );
                                      
                                      Navigator.pop(context, treeSpecie);
                                    }
                                  );
                                },
                              ),
                            ),
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


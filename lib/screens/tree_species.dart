import 'package:flutter/material.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/tree_specie_service.dart';

class TreeSpecies extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TreeSpecies();
  }

}

class _TreeSpecies extends State<TreeSpecies>{

  final TreeSpecieService treeSpecieService = new TreeSpecieService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Especies disponibles'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: treeSpecieService.obtenerEspecies(),
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
                                  leading: Icon(Icons.eco, color: Colors.green,),
                                  title: Text(snapshot.data[index]["name"] + " (${snapshot.data[index]["description"]})"),
                                  // subtitle: Text(snapshot.data[index]["description"]),
                                  onTap: () {
                                  },
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("Salir")
                          )
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
      ) 
    );
  }
}
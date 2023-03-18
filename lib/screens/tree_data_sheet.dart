import 'package:flutter/material.dart';
import 'package:tree_timer_app/common/widgets/custom_alertdialogtreespecies.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/tree_data_sheets_service.dart';
import 'package:tree_timer_app/features/tree_specie_service.dart';
import 'package:tree_timer_app/models/project.dart';
import 'package:tree_timer_app/models/tree_specie.dart';

class TreeDataSheet extends StatefulWidget{

  final Project project;

  TreeDataSheet({
    Key? key,
    required this.project
  }) : super(key:key);

  @override
  State<TreeDataSheet> createState() => _TreeDataSheetState();
}

class _TreeDataSheetState extends State<TreeDataSheet>{

  TreeSpecieService treeSpecieService = new TreeSpecieService();
  TreeDataSheetService treeDataSheetService = new TreeDataSheetService();
  final treeSpecieController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _specificTreeId = '';
  TreeSpecie? _specie;
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(30.0),
            width: 400,
            height: 450,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ID de árbol',
                  ),
                  onSaved: (value) {
                    _specificTreeId = value!;
                  },
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  readOnly: true,
                  controller: treeSpecieController,
                  decoration: InputDecoration(
                    labelText: 'Especie de árbol',
                  ),
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade200)),
                  onPressed: () async {
                    _specie = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomAlertDialogTreeSpecies();
                      }
                    );
                    // We set the value of tree specie text form field
                    treeSpecieController.value = TextEditingValue(text: _specie?.name ?? '');
                  },
                  child: Text('Seleccionar especie de árbol')
                ),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notas de árbol',
                  ),
                  onSaved: (value) {
                    _description = value!;
                  },
                )
              ]
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            // To prevent same tag between floating action buttons
            heroTag: UniqueKey(),
            onPressed: () async {
              bool? deleteDataSheet = await showConfirmDialog(context, "¿Desea borrar la ficha de datos del árbol?", "");
              if(deleteDataSheet == true){
                //Delete data sheet
              }else{
                return null;
              }
            },
            child: Icon(Icons.delete),
          ),
          SizedBox(width: 16.0),
          FloatingActionButton(
            // To prevent same tag between floating action buttons
            heroTag: UniqueKey(),
            onPressed: () async {
              if (_formKey.currentState!.validate())
              {
                // Save form values
                _formKey.currentState!.save();
                bool? saveDataSheet = await showConfirmDialog(context, "¿Desea guardar la ficha de datos del árbol?", "");
                if(saveDataSheet == true){
                  //Save data sheet
                  treeDataSheetService.newTreeDataSheet(context: context, project_id: widget.project.id, treeSpecie: _specie!, treeId: _specificTreeId, description: _description);
                }else{
                  return null;
                }
              }  
            },
            tooltip: 'Guardar ficha de datos',
            child: const Icon(Icons.save),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
 
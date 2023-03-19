import 'package:flutter/material.dart';
import 'package:tree_timer_app/common/widgets/custom_alertdialogtreespecies.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/tree_data_sheets_service.dart';
import 'package:tree_timer_app/features/tree_specie_service.dart';
import 'package:tree_timer_app/models/project.dart';
import 'package:tree_timer_app/models/tree_data_sheet.dart';
import 'package:tree_timer_app/models/tree_specie.dart';

class TreeDataSheetScreen extends StatefulWidget{

  TreeDataSheet? treeDataSheet;
  final Project project;
  String? specificTreeIdValue;
  TreeSpecie? selectedSpecie;
  String? descriptionValue;

  TreeDataSheetScreen({
    Key? key,
    required this.treeDataSheet,
    required this.project,
  }) : super(key:key);

  @override
  State<TreeDataSheetScreen> createState() => _TreeDataSheetScreenState();
}

class _TreeDataSheetScreenState extends State<TreeDataSheetScreen>{

  TreeSpecieService treeSpecieService = new TreeSpecieService();
  TreeDataSheetService treeDataSheetService = new TreeDataSheetService();
  final treeSpecieController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<dynamic> initSpecieValue() async {
    widget.selectedSpecie = TreeSpecie.fromJson(await treeSpecieService.findSpecie(widget.treeDataSheet!.tree_specie_id));
    treeSpecieController.value = TextEditingValue(text: widget.selectedSpecie!.name);
  }

  @override
  void initState() {
    // Initialize value of controller if it is valid
    if(widget.treeDataSheet != null)
    {
      initSpecieValue();
    }
    super.initState();
  }

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
                  initialValue: widget.treeDataSheet?.specific_tree_id,
                  decoration: InputDecoration(
                    labelText: 'ID de árbol',
                  ),
                  onSaved: (value) {
                    widget.specificTreeIdValue = value!;
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
                    widget.selectedSpecie = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomAlertDialogTreeSpecies();
                      }
                    );
                    // We set the value of tree specie text form field
                    treeSpecieController.value = TextEditingValue(text: widget.selectedSpecie?.name ?? '');
                  },
                  child: Text('Seleccionar especie de árbol')
                ),
                TextFormField(
                  initialValue: widget.treeDataSheet?.description,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notas de árbol',
                  ),
                  onSaved: (value) {
                    widget.descriptionValue = value!;
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
              if(deleteDataSheet == true && widget.treeDataSheet != null){
                treeDataSheetService.deleteTreeDataSheet(context: context, id: widget.treeDataSheet!.id);
                Navigator.pop(context);
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
                  // Update data sheet or save if does not exists
                  if(widget.treeDataSheet != null)
                  {
                    treeDataSheetService.updateTreeDataSheet(
                      context: context,
                      id: widget.treeDataSheet!.id,
                      project_id: widget.project.id,
                      treeSpecie: widget.selectedSpecie!,
                      treeId: widget.specificTreeIdValue!,
                      description: widget.descriptionValue
                    );
                  }
                  else{
                    treeDataSheetService.newTreeDataSheet(context: context, project_id: widget.project.id, treeSpecie: widget.selectedSpecie!, treeId: widget.specificTreeIdValue!, description: widget.descriptionValue);
                  }
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
 
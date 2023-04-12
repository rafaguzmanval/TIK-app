import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tree_timer_app/common/widgets/custom_alertdialogtreespecies.dart';
import 'package:tree_timer_app/common/widgets/custom_floating_buttons_bottom.dart';
import 'package:tree_timer_app/common/widgets/custom_flutter_map.dart';
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
  LatLng? position;

  TreeDataSheetScreen({
    Key? key,
    required this.treeDataSheet,
    required this.project,
    this.position,
  }) : super(key:key);

  @override
  State<TreeDataSheetScreen> createState() => _TreeDataSheetScreenState();
}

class _TreeDataSheetScreenState extends State<TreeDataSheetScreen>{

  TreeSpecieService treeSpecieService = new TreeSpecieService();
  TreeDataSheetService treeDataSheetService = new TreeDataSheetService();
  final treeSpecieController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // Add position
  LatLng _position = LatLng(0, 0);
  // Edit boolean
  bool isEditing = false;

  Future<dynamic> initSpecieValue() async {
    widget.selectedSpecie = TreeSpecie.fromJson(await treeSpecieService.findSpecie(widget.treeDataSheet!.tree_specie_id));
    treeSpecieController.value = TextEditingValue(text: widget.selectedSpecie!.name);
  }

  void onDeleted() async {
    bool? deleteDataSheet = await showConfirmDialog(context, "¿Desea borrar la ficha de datos del árbol?", "");
    if(deleteDataSheet == true && widget.treeDataSheet != null){
      treeDataSheetService.deleteTreeDataSheet(context: context, id: widget.treeDataSheet!.id);
      Navigator.pop(context);
    }else{
      return null;
    }
  }

  void onSaved () async {
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
  }  

  @override
  void initState() {
    // Initialize value of controller if it is valid
    if(widget.treeDataSheet != null)
    {
      initSpecieValue();
    }
    // Init the current position to 0 if its null
    if (widget.position != null) {
      _position = widget.position!;
    }
    // If new data sheet, isEditing = true to set Save icon
    if(widget.treeDataSheet == null){
      isEditing = true;
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
            // THIS CANNOT BE 800px
            width: double.infinity,
            height: 800,
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
                SizedBox(height: 15,),
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
                SizedBox(height: 20,),
                TextFormField(
                  initialValue: widget.treeDataSheet?.description,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notas de árbol',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSaved: (value) {
                    widget.descriptionValue = value!;
                  },
                ),
                SizedBox(height: 20,),
                CustomMap(currentPosition: _position,),
              ]
            ),
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButtonsBottom(parentWidget: widget, onSaved: onSaved, onDeleted: onDeleted, formKey: _formKey, isEditing: isEditing,),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}




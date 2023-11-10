import 'package:flutter/material.dart';
import 'package:tree_inspection_kit_app/models/measurement.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomMeasurementTable extends StatefulWidget{

  final List<Measurement> list;
  final Function(Measurement) onDelete;
  final bool isEditing;

  CustomMeasurementTable({
    super.key,
    required this.list,
    required this.onDelete,
    required this.isEditing, 
  });

  @override
  State<StatefulWidget> createState() => _CustomMeasurementTableState();

}

class _CustomMeasurementTableState extends State<CustomMeasurementTable>{

  List<DataColumn> columnsList = [];
  List<DataRow> rowsList = [];

  void setColumns(bool _isEditing)
  {
    if(_isEditing)
    {
      columnsList = [
              DataColumn(label: Text('${AppLocalizations.of(context)!.dist}\n(cm)')),
              DataColumn(label: Text('${AppLocalizations.of(context)!.time}\n(µs)')),
              DataColumn(label: Text('${AppLocalizations.of(context)!.avgVel}\n(m/s)')),
              DataColumn(label: Text(AppLocalizations.of(context)!.deleteQuestion)),
            ];
    }
    else{
      columnsList = [
              DataColumn(label: Text('${AppLocalizations.of(context)!.dist}\n(cm)')),
              DataColumn(label: Text('${AppLocalizations.of(context)!.time}\n(µs)')),
              DataColumn(label: Text('${AppLocalizations.of(context)!.avgVel}\n(m/s)')),
            ];
    }
  }

  void setRows(bool _isEditing)
  {
    if(_isEditing)
    {
      rowsList = widget.list.map((item) => DataRow(cells: [
                      DataCell(Text(item.distance.toString())),
                      DataCell(Text(item.time.toString())),
                      DataCell(Text(item.avgVelocity.toString())),
                      widget.isEditing ? DataCell(
                        FloatingActionButton(
                          heroTag: UniqueKey(),
                          mini: true,
                          child: Icon(Icons.delete),
                          onPressed: () {
                            widget.onDelete(item);
                            setState(() {
                              // We need to call again the setRows function in order to refresh
                              setRows(_isEditing);
                            });
                          },
                        )
                      ) : DataCell.empty,
                    ]))
                .toList();
    }
    else{
      rowsList = widget.list.map((item) => DataRow(cells: [
                      DataCell(Text(item.distance.toString())),
                      DataCell(Text(item.time.toString())),
                      DataCell(Text(item.avgVelocity.toString())),
                    ]))
                .toList();
    }
  }

  @override
  void initState(){
    super.initState();
    // setColumns(widget.isEditing);
    setRows(widget.isEditing);
  }

  // Init columns
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    setColumns(widget.isEditing);
  }

  @override
  Widget build(BuildContext context) {
    // Set rows first
    setRows(widget.isEditing);
    return DataTable(
      columnSpacing: 25,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            columns: columnsList,
            rows: rowsList,
          );
  }

}
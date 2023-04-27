import 'package:flutter/material.dart';
import 'package:tree_timer_app/models/measurement.dart';

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
              const DataColumn(label: Text('Dist.\n(cm)')),
              const DataColumn(label: Text('Tiempo\n(µs)')),
              const DataColumn(label: Text('Vel.\nmedia\n(m/s)')),
              const DataColumn(label: Text('¿Borrar?')),
            ];
    }
    else{
      columnsList = [
              const DataColumn(label: Text('Dist.\n(cm)')),
              const DataColumn(label: Text('Tiempo\n(µs)')),
              const DataColumn(label: Text('Vel.\nmedia\n(m/s)')),
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
    setColumns(widget.isEditing);
    setRows(widget.isEditing);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
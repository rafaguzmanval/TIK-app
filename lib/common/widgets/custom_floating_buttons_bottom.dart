import 'package:flutter/material.dart';

class CustomFloatingButtonsBottom extends StatelessWidget {

  const CustomFloatingButtonsBottom({
    super.key,
    required this.parentWidget,
    required this.onSaved,
    required this.onDeleted,
    required GlobalKey<FormState> formKey,
    required this.isEditing,
  }) : _formKey = formKey;

  final Widget parentWidget;
  final GlobalKey<FormState> _formKey;
  final Function onSaved;
  final Function onDeleted;
  final bool isEditing;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          // To prevent same tag between floating action buttons
          heroTag: UniqueKey(),
          onPressed: () async {
            onDeleted();
          },
          child: Icon(Icons.delete),
        ),
        SizedBox(width: 16.0),
        FloatingActionButton(
          // To prevent same tag between floating action buttons
          heroTag: UniqueKey(),
          onPressed: () async {
            onSaved();
          },
          tooltip: isEditing ? 'Guardar proyecto' : 'Editar proyecto',
          child: isEditing ? const Icon(Icons.save) : const Icon(Icons.edit),
        )
      ],
    );
  }
}
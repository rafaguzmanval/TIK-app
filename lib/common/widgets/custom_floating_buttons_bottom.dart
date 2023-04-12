import 'package:flutter/material.dart';

class CustomFloatingButtonsBottom extends StatelessWidget {
  const CustomFloatingButtonsBottom({
    super.key,
    required this.parentWidget,
    required this.onSaved,
    required this.onDeleted,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final Widget parentWidget;
  final Function onSaved;
  final Function onDeleted;
  final GlobalKey<FormState> _formKey;

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
          tooltip: 'Guardar ficha de datos',
          child: const Icon(Icons.save),
        )
      ],
    );
  }
}
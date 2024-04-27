import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomFloatingButtonsBottom extends StatelessWidget {

  CustomFloatingButtonsBottom({
    super.key,
    required this.parentWidget,
    required this.onSaved,
    required this.onDeleted,
    required this.isEditing,
    this.icon1 = const Icon(Icons.delete),
    this.icon2 = const Icon(Icons.save),
  });

  final Widget parentWidget;
  final Function onSaved;
  final Function onDeleted;
  final bool isEditing;
  Icon? icon1;
  Icon? icon2;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        /*FloatingActionButton(
          // To prevent same tag between floating action buttons
          heroTag: UniqueKey(),
          onPressed: () async {
            onDeleted();
          },
          child: icon1,
        ),*/
        SizedBox(width: 16.0),
        FloatingActionButton(
          // To prevent same tag between floating action buttons
          heroTag: UniqueKey(),
          onPressed: () async {
            onSaved();
          },
          tooltip: isEditing ? AppLocalizations.of(context)!.save : AppLocalizations.of(context)!.edit,
          child: isEditing ?  icon2 : const Icon(Icons.edit),
        )
      ],
    );
  }
}
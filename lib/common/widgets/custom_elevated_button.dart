import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {

  final String title;
  late Icon  icon;
  final VoidCallback onPressed;

  CustomElevatedButton({
    super.key, required this.title, required this.onPressed, this.icon = const Icon(Icons.star, color: Colors.transparent),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: icon,
            ),
            Expanded(
                flex: 7,
                child: Text(title)
            )
          ],
        )
    );
  }
}
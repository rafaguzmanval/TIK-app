import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomPositionedLoginAnimation extends StatelessWidget
{
  final Widget child;

  const CustomPositionedLoginAnimation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
            child: Column(
              children: [
                SizedBox(
                  height: 125,
                  width: 125,
                  child: this.child
                  ),
              ],
            )
          );
  }

}
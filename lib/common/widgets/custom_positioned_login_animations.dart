import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomPositionedLoginAnimation extends StatelessWidget
{
  final Widget child;
  final double  height;
  final double  width;
  final double left;
  final double top;
  final double right;
  final double bottom;

  const CustomPositionedLoginAnimation({super.key, required this.child, this.height = 125, this.width = 125,
                                        this.left = 0, this.right = 0, this.top = 0, this.bottom = 0});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: SizedBox(
                height: height,
                width: width,
                child: this.child
                ),
            ),
          ),
        ],
      )
    );
  }

}
import 'package:flutter/material.dart';

class ArrowListScroll extends StatelessWidget {
  const ArrowListScroll({
    super.key,
    required this.scrollController,
    required 
  });

  final ScrollController scrollController;
  final bool downArrow = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        alignment: Alignment.center,
        child: Icon(Icons.arrow_downward),
      ),
    );
  }
}
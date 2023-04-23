import 'package:flutter/material.dart';

class ArrowUpWardListScroll extends StatelessWidget {
  const ArrowUpWardListScroll({
    super.key,
    required this.scrollController,
    required 
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        alignment: Alignment.center,
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
}
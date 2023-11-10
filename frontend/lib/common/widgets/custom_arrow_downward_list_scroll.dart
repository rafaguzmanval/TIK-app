import 'package:flutter/material.dart';

class ArrowDownWardListScroll extends StatelessWidget {
  const ArrowDownWardListScroll({
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
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        alignment: Alignment.center,
        child: Icon(Icons.arrow_downward),
      ),
    );
  }
}
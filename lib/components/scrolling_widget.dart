import 'package:flutter/material.dart';

class ScrollIndicator extends StatelessWidget {
  final ScrollController scrollController;

  ScrollIndicator({required this.scrollController, required Center child});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      thickness: 6.0,
      radius: Radius.circular(10),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          height: 500, // Adjust this height based on the content you have
          color: Colors.transparent,
        ),
      ),
    );
  }
}

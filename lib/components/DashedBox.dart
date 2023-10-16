import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashedBox extends StatelessWidget {
  List<Widget> widget;
  bool isEnabled;

  DashedBox({
    super.key,
    required this.widget,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: DottedBorder(
        color: isEnabled ? Colors.black : Colors.grey,
        dashPattern: [8, 4],
        strokeWidth: 1,
        padding: EdgeInsets.all(8),
        borderPadding: EdgeInsets.all(4),
        child: Padding(
          padding: EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: widget,
            ),
          ),
        ),
    );
  }
}
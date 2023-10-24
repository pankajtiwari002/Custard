import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnalyticsButtonCard extends StatelessWidget {
  Icon leadingIcon;
  String title;
  String mainNum;
  String hikePercent;
  Function() onPressed;

  AnalyticsButtonCard({
    required this.leadingIcon,
    required this.title,
    required this.mainNum,
    required this.hikePercent,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
          child: Card(
          color: CustardColors.buttonLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leadingIcon,
                    Text(
                      title,
                      style: TextStyle(
                        color: CustardColors.appTheme,
                        fontSize: 11.43,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    Icon(Icons.arrow_right, color: CustardColors.appTheme)
                  ],
                ),
                SizedBox(
                  width: 12,
                  height: 24,
                ),
                Text(
                  mainNum,
                  style: TextStyle(
                    color: Color(0xFF090B0E),
                    fontSize: 17.14,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    height: 0.09,
                  ),
                ),
                SizedBox(
                  width: 12,
                  height: 12,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: hikePercent,
                        style: TextStyle(
                          color: Color(0xFF00BC32),
                          fontSize: 11.43,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      TextSpan(
                        text: 'from last week',
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 11.43,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
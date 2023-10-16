import 'package:flutter/cupertino.dart';

class TitleBodyContainer extends StatelessWidget {
  String title;
  String body;

  TitleBodyContainer(this.title, this.body, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
      child: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text( title,
              style: const TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 24,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w700,
                height: 0
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
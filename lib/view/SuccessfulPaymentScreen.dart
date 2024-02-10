import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessfulPaymentScreen extends StatelessWidget {
  const SuccessfulPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/verify.svg"),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Payment is successful.',
              style: TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 18,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.20,
              ),
            ),
            Text(
              "You're all set for The art of living! Here are the ticket:",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF909DAD),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.20,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFF2EFFF))),
                child: Text(
                  'View ticket',
                  style: TextStyle(
                    color: Color(0xFF7B61FF),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.20,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

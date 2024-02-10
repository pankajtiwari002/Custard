import 'package:custard_flutter/view/BankDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellingTicketScrenn extends StatelessWidget {
  const SellingTicketScrenn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Event",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(children: [
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: Color(0xFFF2EFFF),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(const IconData(0xe040, fontFamily: 'MaterialIcons'),
                  color: Color(0xFF665EE0)),
            ),
            title: Text(
              'Enter bank a/c details',
              style: TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Choose bank or enter ifsc details',
              style: TextStyle(
                color: Color(0xFF546881),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: (){
              Get.to(() => BankDetailsScreen(isUpi: false));
            },
          ),
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: Color(0xFFF2EFFF),
                  borderRadius: BorderRadius.circular(8)),
              child: Image.asset("assets/images/upi.png"),
            ),
            title: Text(
              'Enter UPI ID of any UPI App',
              style: TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Paymet to bank account using UPI ID',
              style: TextStyle(
                color: Color(0xFF546881),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: (){
              Get.to(() => BankDetailsScreen(isUpi: true));
            },
          ),
        ]),
      ),
    );
  }
}

import 'package:custard_flutter/components/CustardButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddHostScreen extends StatelessWidget {
  const AddHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Add Host",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a host to highlight them on the event page or to get help managing the event.',
              style: TextStyle(
                color: Color(0xFF546881),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Enter email',
              style: TextStyle(
                color: Color(0xFF141414),
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text('Enter Email id of the host'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'Host settings',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
                height: 0.06,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            SwitchListTile(
              value: true,
              onChanged: (val) {},
              title: Text(
                'Show them on event page',
                style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                  height: 0.10,
                ),
              ),
            ),
            SwitchListTile(
              value: true,
              onChanged: (val) {},
              title: Text(
                'Has manage access',
                style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                  height: 0.10,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustardButton(
          onPressed: () {},
          buttonType: ButtonType.POSITIVE,
          label: "Invite Host",
          backgroundColor: Color(0xFF7B61FF),
          textColor: Colors.white,
      ),
    );
  }
}

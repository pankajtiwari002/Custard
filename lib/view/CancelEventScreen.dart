import 'package:custard_flutter/components/CustardButton.dart';
import 'package:flutter/material.dart';

class CancelEventScreen extends StatelessWidget {
  const CancelEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reason Of Cancellation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 236, 205, 205),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.tag,
                color: Color(0xFFFF3A3A),
                size: 32,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'Cancel Event',
              style: TextStyle(
                color: Color(0xFF090B0E),
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'If you aren’t able to host your event, you can cancel. This will permanently delete your event. It cannot be undone.',
              style: TextStyle(
                color: Color(0xFF546881),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w400,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Write a reason for Cancellation",
                hintStyle: TextStyle(
                  color: Colors.grey
                )
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: CustardButton(
                  onPressed: () {},
                  buttonType: ButtonType.POSITIVE,
                  label: "Cancel Event",
                  backgroundColor: Color(0xFFFF3A3A),
                  textColor: Colors.white,
                ),
      ),
    );
  }
}

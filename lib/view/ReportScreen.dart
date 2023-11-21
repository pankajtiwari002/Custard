import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/CustardButton.dart';

class ReportScreen extends StatelessWidget {
  Rx<int> selectedValue = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Report User',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You won’t be able to receive any message or call from this user.',
                  style: TextStyle(
                    color: Color(0xFF090B0E),
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Reason for reporting:',
                  style: TextStyle(
                    color: Color(0xFF546881),
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                RadioListTile(
                  title: Text(
                    'Spam',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: 1,
                  onChanged: (val) {
                    print(val);
                    selectedValue.value = val!;
                  },
                  groupValue: selectedValue.value,
                ),
                RadioListTile(
                  title: Text(
                    'Privacy violation',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: 2,
                  onChanged: (val) {
                    print(val);
                    selectedValue.value = val!;
                  },
                  groupValue: selectedValue.value,
                ),
                RadioListTile(
                  title: Text(
                    'Bullying',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: 3,
                  onChanged: (val) {
                    print(val);
                    selectedValue.value = val!;
                  },
                  groupValue: selectedValue.value,
                ),
                RadioListTile(
                  title: Text(
                    'Offensive messages',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: 4,
                  onChanged: (val) {
                    print(val);
                    selectedValue.value = val!;
                  },
                  groupValue: selectedValue.value,
                ),
                RadioListTile(
                  title: Text(
                    'Other',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: 5,
                  onChanged: (val) {
                    print(val);
                    selectedValue.value = val!;
                  },
                  groupValue: selectedValue.value,
                ),
                if (selectedValue.value == 5)
                  TextField(
                    decoration:
                        InputDecoration(label: Text("Reason (optional)")),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Block',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF7B61FF)),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  "Discard",
                  style: TextStyle(color: Color(0xFF7B61FF), fontSize: 16),
                ))
          ],
        ),
      ),
    );
  }
}

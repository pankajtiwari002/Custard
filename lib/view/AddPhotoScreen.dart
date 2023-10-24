import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:custard_flutter/controllers/AddPhotoController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPhotoScreen extends StatelessWidget {
  var controller = Get.put(AddPhotoController());

  AddPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF242424),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {  }
        ),
        title: Text(
          'Social Dance Tribe',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
                'Group name',
                style: TextStyle(
                    color: Color(0xFF141414),
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600
                )
            ),
            Material(
              child: CustardTextField(
                  labelText: "name",
                  controller: controller.grpName
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(100, (index) {
                  return Center(
                    child: _photoTile(),
                  );
                }),
              )
            ),
            CustardButton(
                onPressed: () {},
                buttonType: ButtonType.NEGATIVE,
                label: "Add Participants"
            )
          ],
        ),
      ),
    );
  }

  _photoTile() {
    return Image(image: NetworkImage("https://via.placeholder.com/100x100"));
  }
}
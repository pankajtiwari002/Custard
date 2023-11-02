import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPhotoScreen extends StatelessWidget {
  String imageUrl;
  ViewPhotoScreen({super.key,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text("Download", style: TextStyle(color: Colors.purple)))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(imageUrl),fit: BoxFit.fitWidth),
          color: Colors.black,
        )
      )
    );
  }
}

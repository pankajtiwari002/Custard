import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:custard_flutter/view/AddPhotoScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryScreen extends StatelessWidget {

  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _yourPhoto(),
        _groups()
      ],
    );
  }

  _yourPhoto() {
    var photos = [
      "assets/temp.png",
      "assets/temp.png",
      "assets/temp.png",
      "assets/temp.png",
      "assets/temp.png",
      "assets/temp.png"
    ].obs;

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Column(
        children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Photos',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 18,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700
              ),
            ),
            TextButton(
                onPressed: () {
                  Get.to(AddPhotoScreen());
                },
                child: Text(
                  'View all',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: CustardColors.appTheme,
                      fontSize: 12,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700
                  ),
                )
            )
          ],
        ),
          Container(
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) =>
                    _photoCardUI(photos[index])
            ),
          ),
        ]
      ),
    );
  }

  _photoCardUI(String data) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Image(image: NetworkImage("https://via.placeholder.com/150x150")),
      ),
    );
  }

  _groups() {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Groups',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          _groupsTile(GalleryTileData(grpIcon: "https://via.placeholder.com/150x150", name: "name", recentImage: "https://via.placeholder.com/150x150")),
          _groupsTile(GalleryTileData(grpIcon: "https://via.placeholder.com/150x150", name: "name", recentImage: "https://via.placeholder.com/150x150")),
          _groupsTile(GalleryTileData(grpIcon: "https://via.placeholder.com/150x150", name: "name", recentImage: "https://via.placeholder.com/150x150")),
          _groupsTile(GalleryTileData(grpIcon: "https://via.placeholder.com/150x150", name: "name", recentImage: "https://via.placeholder.com/150x150")),
          _groupsTile(GalleryTileData(grpIcon: "https://via.placeholder.com/150x150", name: "name", recentImage: "https://via.placeholder.com/150x150")),
          _groupsTile(GalleryTileData(grpIcon: "https://via.placeholder.com/150x150", name: "name", recentImage: "https://via.placeholder.com/150x150")),
        ],
      ),
    );
  }

  _groupsTile(GalleryTileData data) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(data.grpIcon),
          ),
          const SizedBox(width: 16),
          Text(
            data.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          Spacer(
            flex: 1,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              width: 60,
              height: 60,
              image: NetworkImage(data.recentImage),
            ),
          )
        ],
      ),
    );
  }
}

class GalleryTileData {
  String grpIcon;
  String name;
  String recentImage;

  GalleryTileData({
    required this.grpIcon,
    required this.name,
    required this.recentImage
  });
}
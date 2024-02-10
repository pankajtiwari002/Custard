import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:custard_flutter/view/AllPhotosScreen.dart';
import 'package:custard_flutter/view/GroupCreationScreen.dart';
import 'package:custard_flutter/view/GroupImageScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AddParticipants.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Gallery',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.20,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => GroupCreationScreen());
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.white,
              )),
        ],
      ),
      body: ListView(
        children: [_yourPhoto(), _groups()],
      ),
    );
  }

  _yourPhoto() {
    var photos = [
      "assets/avatar.png",
      "assets/avatar.png",
      "assets/avatar.png",
      "assets/avatar.png",
      "assets/avatar.png",
      "assets/avatar.png"
    ].obs;

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                  fontWeight: FontWeight.w700),
            ),
            TextButton(
                onPressed: () {
                  // Get.to(() => GroupImageScreen());
                },
                child: Text(
                  'View all',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: CustardColors.appTheme,
                      fontSize: 12,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700),
                ))
          ],
        ),
        Container(
          height: 100,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) =>
                  _photoCardUI(photos[index])),
        ),
      ]),
    );
  }

  _photoCardUI(String data) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(data), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10)),
      // child: Image(image: NetworkImage("https://via.placeholder.com/150x150")),,
    );
  }

  _groups() {
    MainController mainController = Get.find();
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
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('communityId',
                    isEqualTo: mainController.currentCommunityId)
                // .where('dateTime',
                //     isLessThan: DateTime.now().millisecondsSinceEpoch)
                // .orderBy('dateTime', descending: true)
                .snapshots(),
            builder: ((context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<dynamic> userEvents = snapshot.data!.docs;
                  log("length: " + userEvents.length.toString());
                  print(userEvents[1]['id']);
                  return ListView.builder(
                      primary: false,
                      itemCount: userEvents.length,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        log(snapshot.data!.docs[index]['communityId']);
                        // log(index.toString());
                        // return Text("Hi");
                        if (snapshot.data!.docs[index]['dateTime'] <
                            DateTime.now().millisecondsSinceEpoch) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Get.to(() => AllPhotoScreen(
                                        snapshot: snapshot,
                                        index: index,
                                      ));
                                },
                                title: Text(
                                  snapshot.data!.docs[index]['title'],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            snapshot.data!.docs[index]
                                                ['coverPhotoUrl'],
                                          ),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // Divider()
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }));
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            }),
          )
          // FutureBuilder(
          //     future: FirebaseFirestore.instance
          //         .collection("gallery")
          //         .where("communityId",
          //             isEqualTo: mainController.currentCommunityId)
          //         .where('chapterId',
          //             isEqualTo:
          //                 mainController.currentCommunity.value!.chapters[0])
          //         .get(),
          //     builder: ((context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.active ||
          //           snapshot.connectionState == ConnectionState.done) {
          //         print("snaphot");
          //         if (snapshot.hasData) {
          //           print("snaphot has data");
          //           // print(snapshot.data!.docs[0].id);
          //           return ListView.builder(
          //               shrinkWrap: true,
          //               primary: false,
          //               itemCount: snapshot.data!.docs.length,
          //               itemBuilder: (context, index) {
          //                 return FutureBuilder(
          //                     future: FirebaseFirestore.instance
          //                         .collection("events")
          //                         .doc(snapshot.data!.docs[index]['eventId'])
          //                         .get(),
          //                     builder: (context, snap) {
          //                       if (snap.connectionState ==
          //                               ConnectionState.active ||
          //                           snap.connectionState ==
          //                               ConnectionState.done) {
          //                         if (snap.hasData) {
          //                           return InkWell(
          //                             onTap: () {
          //                               Get.to(() => GroupImageScreen());
          //                               // Get.to(() => AllPhotos(
          //                               //     images: snapshot.data!.docs[index]
          //                               //         ['urls']));
          //                             },
          //                             child: _groupsTile(GalleryTileData(
          //                                 grpIcon: snap.data!['coverPhotoUrl'],
          //                                 name: snap.data!['title'],
          //                                 recentImage: snapshot
          //                                     .data!.docs[index]['urls'][0])),
          //                           );
          //                         }
          //                       }
          //                       return Container();
          //                     });
          //               });
          //         }
          //       }
          //       print("snapshot has error");
          //       return Container();
          //     })),
          // _groupsTile(GalleryTileData(
          //     grpIcon: "https://via.placeholder.com/150x150",
          //     name: "name",
          //     recentImage:
          //         "https://t3.ftcdn.net/jpg/02/48/42/64/360_F_248426448_NVKLywWqArG2ADUxDq6QprtIzsF82dMF.jpg")),
          // _groupsTile(GalleryTileData(
          //     grpIcon: "https://via.placeholder.com/150x150",
          //     name: "name",
          //     recentImage: "https://via.placeholder.com/150x150")),
          // _groupsTile(GalleryTileData(
          //     grpIcon: "https://via.placeholder.com/150x150",
          //     name: "name",
          //     recentImage: "https://via.placeholder.com/150x150")),
          // _groupsTile(GalleryTileData(
          //     grpIcon: "https://via.placeholder.com/150x150",
          //     name: "name",
          //     recentImage: "https://via.placeholder.com/150x150")),
          // _groupsTile(GalleryTileData(
          //     grpIcon: "https://via.placeholder.com/150x150",
          //     name: "name",
          //     recentImage: "https://via.placeholder.com/150x150")),
          // _groupsTile(GalleryTileData(
          //     grpIcon: "https://via.placeholder.com/150x150",
          //     name: "name",
          //     recentImage: "https://via.placeholder.com/150x150")),
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
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(data.recentImage), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(15)),
          ),
        ],
      ),
    );
  }
}

class GalleryTileData {
  String grpIcon;
  String name;
  String recentImage;

  GalleryTileData(
      {required this.grpIcon, required this.name, required this.recentImage});
}

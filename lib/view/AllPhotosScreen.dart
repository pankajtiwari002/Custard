import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/repo/FirestoreMethods.dart';
import 'package:custard_flutter/repo/StorageMethods.dart';
import 'package:custard_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'InvitePeopleScreen.dart';
import 'ViewPhotoScreen.dart';

class AllPhotoScreen extends StatefulWidget {
  final snapshot;
  int index;
  AllPhotoScreen({super.key, required this.snapshot, required this.index});

  @override
  State<AllPhotoScreen> createState() => _AllPhotoScreenState();
}

class _AllPhotoScreenState extends State<AllPhotoScreen> {
  MainController mainController = Get.find();

  Uint8List? image;

  Future<void> uploadData(String url) async {
    try {
      if (!widget.snapshot.data!.docs[widget.index]
          .data()
          .containsKey("galleryId")) {
        final ref = FirebaseFirestore.instance.collection("gallery").doc();
        String galleryId = ref.id;
        await ref.set({
          "chapterId": mainController.currentCommunity.value!.chapters[0],
          "communityId": mainController.currentCommunityId,
          "createdOn": DateTime.now().millisecondsSinceEpoch,
          "eventId": widget.snapshot.data!.docs[widget.index].id,
          "participants": [],
          "urls": [
            url,
          ]
        });
        log("eventId: " + widget.snapshot.data!.docs[widget.index].id);
        FirebaseFirestore.instance.collection("events").doc(widget.snapshot.data!.docs[widget.index].id).update({
          "galleryId": galleryId,
        });
        log("Done");
        setState(() {});
      } else {
        await FirebaseFirestore.instance
            .collection("gallery")
            .doc(widget.snapshot.data!.docs[widget.index]["galleryId"])
            .update({
          "urls": FieldValue.arrayUnion([url]),
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upload Media",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Camera"),
                  onTap: () async {
                    // Add your camera logic here
                    XFile? file = await pickImage(ImageSource.camera);
                    if (file != null) {
                      image = await file.readAsBytes();
                      String imageUrl =
                          await StorageMethods.uploadImageToStorage(
                              "gallery", Uuid().v1(), image!);

                      uploadData(imageUrl);
                    }
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("Gallery"),
                  onTap: () async {
                    // Add your gallery logic here
                    XFile? file = await pickImage(ImageSource.gallery);
                    if (file != null) {
                      image = await file.readAsBytes();
                      String imageUrl =
                          await StorageMethods.uploadImageToStorage(
                              "gallery", Uuid().v1(), image!);

                      uploadData(imageUrl);
                    }
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.link),
                  title: Text("Link"),
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.snapshot.data!.docs[widget.index]['title'],
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {
                showCustomBottomSheet();
              },
              icon: Icon(
                Icons.grid_on,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                log(widget.snapshot.data.docs[widget.index].id);
                Get.to(() => InvitePeopleScreen(
                      eventId: widget.snapshot.data.docs[widget.index].id,
                    ));
              },
              icon: Icon(
                Icons.group,
                color: Colors.white,
              ))
        ],
      ),
      body: !widget.snapshot.data!.docs[widget.index]
              .data()
              .containsKey("galleryId")
          ? Container()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("gallery")
                  .doc(widget.snapshot.data!.docs[widget.index]['galleryId'])
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.active ||
                    snap.connectionState == ConnectionState.done) {
                  if (snap.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 16),
                      child: GridView.custom(
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: [
                            QuiltedGridTile(2, 2),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 2),
                          ],
                        ),
                        childrenDelegate: SliverChildBuilderDelegate(
                          (context, ind) => InkWell(
                            onTap: () {
                              Get.to(() => ViewPhotoScreen(
                                    imageUrl: snap.data!["urls"][ind],
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(snap.data!["urls"][ind]),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          childCount: snap.data!["urls"].length,
                        ),
                      ),
                    );
                  }
                }
                return Container();
              }),
      // body: GridView.custom(
      //   gridDelegate: SliverQuiltedGridDelegate(
      //     crossAxisCount: 4,
      //     mainAxisSpacing: 4,
      //     crossAxisSpacing: 4,
      //     repeatPattern: QuiltedGridRepeatPattern.inverted,
      //     pattern: [
      //       QuiltedGridTile(2, 2),
      //       QuiltedGridTile(1, 1),
      //       QuiltedGridTile(1, 1),
      //       QuiltedGridTile(1, 2),
      //     ],
      //   ),
      //   childrenDelegate: SliverChildBuilderDelegate(
      //     childCount: images.length,
      //     (context, index) => InkWell(
      //       onTap: () {
      //         Get.to(() => ViewPhotoScreen(
      //               imageUrl: images[index],
      //             ));
      //       },
      //       child: Container(
      //         decoration: BoxDecoration(
      //             image: DecorationImage(
      //                 image: NetworkImage(images[index]), fit: BoxFit.cover),
      //             borderRadius: BorderRadius.circular(15)),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

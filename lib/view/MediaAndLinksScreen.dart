import 'package:cached_network_image/cached_network_image.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/view/VideoPlayerScreen.dart';
import 'package:custard_flutter/view/ViewPhotoScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaAndLinksScreen extends StatelessWidget {
  MainController mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    final DatabaseReference _messagesRef = FirebaseDatabase.instance
        .reference()
        .child(
            "${mainController.currentCommunityId}/${mainController.currentCommunity.value!.chapters[0]}/messages");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Group Media',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.20,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                  indicatorColor: Color(0xFF7B61FF),
                  labelStyle: TextStyle(
                    color: Color(0xFF7B61FF),
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(
                      text: "Images",
                    ),
                    Tab(
                      text: "Videos",
                    ),
                    Tab(
                      text: "Others",
                    ),
                  ]),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  height: Get.size.height - AppBar().preferredSize.height - 85,
                  child: TabBarView(children: [
                    imageTab(_messagesRef),
                    videoTab(_messagesRef),
                    otherTab()
                  ]))
            ],
          )),
    );
  }

  Widget imageTab(DatabaseReference messageRef) {
    return FutureBuilder(
        future: FirebaseDatabase.instance
            .reference()
            .child(
                "${mainController.currentCommunityId}/${mainController.currentCommunity.value!.chapters[0]}/messages")
            .get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<dynamic> message = snapshot.data!.children.toList();
              List<String> image = List.empty(growable: true);
              for (var ele in message) {
                if (ele.value['type'] == "IMAGE") {
                  image.add(ele.value['image']);
                }
              }
              return Container(
                child: GridView.builder(
                    itemCount: image.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ViewPhotoScreen(imageUrl: image[index]));
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      CachedNetworkImageProvider(image[index]),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    })),
              );
            }
          }
          return Container();
        }));
  }

  Future<Uint8List?> _generateThumbnail(String videoUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      quality: 50,
    );

    return thumbnail;
  }

  Widget videoTab(DatabaseReference messageRef) {
    return FutureBuilder(
        future: FirebaseDatabase.instance
            .reference()
            .child(
                "${mainController.currentCommunityId}/${mainController.currentCommunity.value!.chapters[0]}/messages")
            .get(),
        builder: ((context, snap) {
          if (snap.connectionState == ConnectionState.active ||
              snap.connectionState == ConnectionState.done) {
            if (snap.hasData) {
              List<dynamic> message = snap.data!.children.toList();
              List<String> video = List.empty(growable: true);
              for (var ele in message) {
                if (ele.value['type'] == "VIDEO") {
                  video.add(ele.value['video']);
                }
              }
              return Container(
                child: GridView.builder(
                    itemCount: video.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: ((context, index) {
                      return FutureBuilder(
                        future: _generateThumbnail(video[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(height: 100);
                          } else if (snapshot.hasError) {
                            return Text('Error loading thumbnail');
                          } else if (snapshot.hasData) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => VideoPlayerScreen(
                                      videoUrl: video[index],
                                    ));
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: MemoryImage(snapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  // padding: EdgeInsets.all(5),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Icon(
                                    Icons.play_arrow,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Text('No thumbnail available');
                          }
                        },
                      );
                    })),
              );
            }
          }
          return Container();
        }));
  }

  Widget otherTab() {
    return Container();
  }
}

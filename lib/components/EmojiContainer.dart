import "package:custard_flutter/controllers/DiscussionController.dart";
import "package:emoji_selector/emoji_selector.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../controllers/MainController.dart";

class EmojiView extends StatelessWidget {
  List messages;
  int index;
  EmojiView({required this.messages, required this.index});

  List<String> emoji = ["👍", "❤️", "😂", "😯", "😥", "🙏"];
  MainController mainController = Get.find();
  DiscussionController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 40,
        width: 250,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 39, 39, 39),
            borderRadius: BorderRadius.circular(20)),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: emoji.length + 1,
            itemBuilder: ((context, ind) {
              if (ind < emoji.length) {
                return InkWell(
                  onTap: () async {
                    DatabaseReference ref = FirebaseDatabase.instance.ref().child(
                        "${mainController.currentCommunityId}/${mainController.currentCommunity.value!.chapters[0]}/messages/${messages[index].value['messageId']}");
                    int val = messages[index].value["reactions"] != null
                        ? messages[index].value["reactions"]["${emoji[ind]}"] ??
                            0
                        : 0;
                    int? val1 = -1;
                    String prevEmoji = "";
                    if (messages[index].value["reactions"] != null) {
                      messages[index]
                          .value["reactions"]["uids"]
                          .forEach((key, val) {
                        if (key == mainController.currentUser!.uid) {
                          val1 = messages[index].value["reactions"]
                                  ["${val['emoji']}"] -
                              1;
                          prevEmoji = val["emoji"];
                        }
                      });
                    }
                    val++;
                    if (val1 != -1) {
                      if (val1 == 0) val1 = null;
                      await ref.update({
                        "reactions/uids/${mainController.currentUser!.uid}": {
                          "emoji": emoji[ind],
                          "uid": mainController.currentUser!.uid
                        },
                        "reactions/${emoji[ind]}": val,
                        "reactions/$prevEmoji": val1,
                      });
                    } else {
                      await ref.update({
                        "reactions/uids/${mainController.currentUser!.uid}": {
                          "emoji": emoji[ind],
                          "uid": mainController.currentUser!.uid
                        },
                        "reactions/${emoji[ind]}": val,
                      });
                    }
                    controller.emojiVisible.value = "";
                    controller.selectedMessage.removeWhere((element) =>
                        (element == messages[index].value["messageId"]));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                    padding: EdgeInsets.all(3),
                    child: Text(
                      emoji[ind],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              } else {
                return InkWell(
                  onTap: () async {
                    Get.bottomSheet(Container(
                      height: 380,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )),
                      child: EmojiSelector(
                        columns: 8,
                        onSelected: (emoji) async {
                          // print(emoji.char);
                          DatabaseReference ref = FirebaseDatabase.instance
                              .ref()
                              .child(
                                  "${mainController.currentCommunityId}/${mainController.currentCommunity.value!.chapters[0]}/messages/${messages[index].value['messageId']}");
                          int val = messages[index].value["reactions"] != null
                              ? messages[index].value["reactions"]
                                      ["${emoji.char}"] ??
                                  0
                              : 0;
                          int? val1 = -1;
                          String prevEmoji = "";
                          if (messages[index].value["reactions"] != null) {
                            messages[index]
                                .value["reactions"]["uids"]
                                .forEach((key, val) {
                              if (key == mainController.currentUser!.uid) {
                                val1 = messages[index].value["reactions"]
                                        ["${val['emoji']}"] -
                                    1;
                                prevEmoji = val["emoji"];
                              }
                            });
                          }
                          val++;
                          if (val1 != -1) {
                            if (val1 == 0) val1 = null;
                            await ref.update({
                              "reactions/uids/${mainController.currentUser!.uid}":
                                  {
                                "emoji": emoji.char,
                                "uid": mainController.currentUser!.uid
                              },
                              "reactions/${emoji.char}": val,
                              "reactions/$prevEmoji": val1,
                            });
                          } else {
                            await ref.update({
                              "reactions/uids/${mainController.currentUser!.uid}":
                                  {
                                "emoji": emoji.char,
                                "uid": mainController.currentUser!.uid
                              },
                              "reactions/${emoji.char}": val,
                            });
                          }
                          Navigator.of(context).pop(emoji);
                          controller.emojiVisible.value = "";
                        },
                      ),
                    ));
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                );
              }
            })),
      ),
    );
  }
}

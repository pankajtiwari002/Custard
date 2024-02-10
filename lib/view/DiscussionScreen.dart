import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/utils/constants.dart';
import 'package:custard_flutter/src/FlowShader.dart';
import 'package:custard_flutter/src/Global.dart';
import 'package:custard_flutter/view/MediaAndLinksScreen.dart';
import 'package:custard_flutter/view/VideoEditor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:custard_flutter/controllers/LocationController.dart';
import 'package:custard_flutter/view/MembersScreen.dart';
import 'package:custard_flutter/view/PollsScreen.dart';
import 'package:custard_flutter/view/ReportScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:custard_flutter/controllers/DiscussionController.dart';
import 'package:custard_flutter/repo/StorageMethods.dart';
import 'package:custard_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';
import '../Global.dart';
import '../components/ChatBox.dart';
import '../components/MessageCard.dart';
import '../components/RecordButton.dart';

class DiscussionScreen extends StatefulWidget{
  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> with AutomaticKeepAliveClientMixin{
  DiscussionController controller = Get.put(DiscussionController());

  MainController mainController = Get.find();

  String? recordFilePath;

  List<String> option = ["Gallery", "Documents", "Location", "Poll"];

  @override
  bool get wantKeepAlive => true;

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  // void startRecord() async {
  void showLocation2Dialog() {
    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container with purple background
            Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xFF7B61FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Location icon with white color
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 36.0,
                  ),
                ],
              ),
            ),

            // Some text below the container
            SizedBox(height: 16),
            Text(
              'Select your options:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // Multiple select options (You can use CheckboxListTile for multiple options)
            Obx(() => CheckboxListTile(
                  title: Text(
                    'for 15 minutes',
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0.10,
                    ),
                  ),
                  value: controller.shareLiveOption.value ==
                      1, // You can manage state using GetX or StatefulWidget
                  onChanged: (newValue) {
                    controller.shareLiveOption.value = 1;
                  },
                )),
            Obx(() => CheckboxListTile(
                  title: Text(
                    'for 1 hour',
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0.10,
                    ),
                  ),
                  value: controller.shareLiveOption.value ==
                      2, // You can manage state using GetX or StatefulWidget
                  onChanged: (newValue) {
                    controller.shareLiveOption.value = 2;
                  },
                )),
            Obx(
              () => CheckboxListTile(
                title: Text(
                  'for 8 hours',
                  style: TextStyle(
                    color: Color(0xFF090B0E),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 0.10,
                  ),
                ),
                value: controller.shareLiveOption.value ==
                    3, // You can manage state using GetX or StatefulWidget
                onChanged: (newValue) {
                  controller.shareLiveOption.value = 3;
                },
              ),
            ),

            // Spacing between options and buttons
            SizedBox(height: 24),

            // Row for buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 120,
                  child: TextButton(
                      onPressed: () {
                        Get.back();
                        controller.selectedButton.value = -1;
                      },
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF665EE0),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
                SizedBox(
                  width: 120,
                  child: TextButton(
                    onPressed: () async {
                      // Perform deletion logic here
                      print("text");
                      final DatabaseReference databaseReference =
                          FirebaseDatabase.instance.ref().child(
                              "${mainController.currentCommunityId}/${mainController.currentCommunity.value!.chapters[0]}/messages");
                      DatabaseReference newMessage =
                          await databaseReference.push();
                      String messageId = newMessage.key!;
                      DateTime time = DateTime.now();
                      int epochTime = time.millisecondsSinceEpoch;
                      Map<String, dynamic> messageJson = {
                        "from": mainController.currentUser!.uid,
                        "messageId": messageId,
                        "text": "",
                        "time": epochTime,
                        "type": "LOCATION"
                      };
                      print("Json Form LOCATION");
                      await newMessage.set(messageJson);
                      Get.back();
                      controller.selectedButton.value = -1;
                    },
                    child: Text(
                      'Share',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF665EE0)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      useSafeArea: false,
    );
  }

  void showLocationDialog() {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image at the center
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset("assets/images/Location_Frame.svg"),
            ),

            // Some text below the image
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Participants in this chat will see your location in real-time. This feature shares your location for the duration you choose even if you’re not using the app. You can stop sharing at any time. ',
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Learn more',
                    style: TextStyle(
                      color: Color(0xFF7B61FF),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // textAlign: TextAlign.center,
            ),

            // Spacing between text and buttons
            SizedBox(height: 24),
          ],
        ),
        actions: [
          SizedBox(
            width: 120,
            child: TextButton(
                onPressed: () {
                  Get.back();
                  controller.selectedButton.value = -1;
                },
                child: Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF665EE0),
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
          SizedBox(
            width: 120,
            child: TextButton(
              onPressed: () async {
                // Perform deletion logic here
                Get.back();
                showLocation2Dialog();
              },
              child: Text(
                'Continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF665EE0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Obx(
            //   () => Visibility(
            //     visible: controller.selectedButton.value == 1,
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         ListTile(
            //           leading: Icon(Icons.image),
            //           title: Text('Image'),
            //           onTap: () async {
            //             // Get.back();
            //             try {
            //               // controller.image.value =
            //               //     await pickImage(ImageSource.gallery);
            //               FilePickerResult? result =
            //                   await FilePicker.platform.pickFiles(
            //                 type: FileType.custom,
            //                 allowedExtensions: ['jpg', 'png', 'mp4'],
            //               );
            //               if (result != null) {
            //                 if (result.files.single.extension! == 'mp4') {
            //                   controller.videoPath = result.files.single.path;
            //                   if (controller.videoPath != null) {
            //                     File video = File(controller.videoPath!);
            //                     controller.video.value =
            //                         await video.readAsBytes();
            //                   }
            //                 } else {
            //                   controller.imagePath = result.files.single.path;
            //                   if (controller.imagePath != null) {
            //                     File image = File(controller.imagePath!);
            //                     controller.image.value =
            //                         await image.readAsBytes();
            //                   }
            //                 }
            //               }
            //               // XFile? file = await pickImage(ImageSource.gallery);
            //               // if (file != null) {
            //               //   Uint8List bytes = await file.readAsBytes();
            //               //   controller.image.value = bytes;
            //               //   var path = await StorageMethods.saveImageToCache(
            //               //       bytes,
            //               //       "${Uuid().v1()}.${file.path.split('.').last}");
            //               //   controller.imagePath = path;
            //               // }
            //               Get.back();
            //               // controller.focusNode.requestFocus();
            //               print("successfull selected");
            //             } catch (e) {
            //               print("select image error: ");
            //               print(e.toString());
            //               Get.back();
            //             }
            //           },
            //         ),
            //         ListTile(
            //           leading: Icon(Icons.video_call_sharp),
            //           title: Text('Video'),
            //           onTap: () async {
            //             // Get.back();
            //             try {
            //               XFile? file = await pickVideo(ImageSource.gallery);
            //               if (file != null) {
            //                 print("asdf");
            //                 controller.video.value = await file.readAsBytes();
            //                 var path = await StorageMethods.saveImageToCache(
            //                     controller.video.value!,
            //                     "${Uuid().v1()}.${file.path.split('.').last}");
            //                 controller.videoPath = path;
            //               }
            //               print("successfull selected");
            //             } catch (e) {
            //               print("select image error: ");
            //               print(e.toString());
            //               Get.back();
            //             }
            //           },
            //         ),
            //         // Divider(
            //         //   thickness: 15,
            //         //   color: Color.fromARGB(109, 240, 235, 192),
            //         // )
            //       ],
            //     ),
            //   ),
            // ),
            Obx(() => Visibility(
                visible: controller.selectedButton.value == 3,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: Image.network(
                        'https://www.google.com/maps/d/thumbnail?mid=1TGjDzIwunYo8hzXL7HH-GdKzyw4&hl=en_US',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ListTile(
                      leading: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF546881),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        'Send selected location',
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Manipal University Jaipur, Dehmi Kalan',
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        showLocationDialog();
                      },
                      leading: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF546881),
                        ),
                        child:
                            SvgPicture.asset('assets/images/location-tick.svg'),
                      ),
                      title: Text(
                        'Share my live location',
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Updated in real time as you move',
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ))),
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildInkWell(
                    'assets/images/image.svg',
                    'assets/images/image_unselected.svg',
                    Color(0xFF318FFF),
                    1, () async {
                  //
                  try {
                    controller.selectedButton.value = 1;
                    // controller.image.value =
                    //     await pickImage(ImageSource.gallery);
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpeg', 'mp4'],
                    );
                    if (result != null) {
                      if (result.files.single.extension! == 'mp4') {
                        controller.videoPath = result.files.single.path;
                        if (controller.videoPath != null) {
                          File video = File(controller.videoPath!);
                          // controller.video.value = await video.readAsBytes();
                          Get.back();
                          print("Hi");
                          await Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    TrimmerView(video)),
                          );
                        }
                      } else {
                        controller.imagePath = result.files.single.path;
                        if (controller.imagePath != null) {
                          File image = File(controller.imagePath!);
                          final img = await image.readAsBytes();
                          final editedImage = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageEditor(
                                image: img, // <-- Uint8List of image
                                blurOption: null,
                                filtersOption: null,
                                savePath: controller.imagePath,
                              ),
                            ),
                          );
                          Get.back();
                          Uint8List? image1 = editedImage;
                          File file = File.fromRawPath(editedImage);
                          controller.imagePath = file.path;
                          try {
                            String type = "TEXT";
                            String? imageUrl;
                            if (image1 != null) {
                              type = "IMAGE";
                              imageUrl =
                                  await StorageMethods.uploadImageToStorage(
                                      'chat/images', Uuid().v1(), image1);
                            }
                            print("imageUrl: $imageUrl");

                            final DatabaseReference databaseReference =
                                FirebaseDatabase.instance.ref().child(
                                    "${mainController.currentCommunityId}/${mainController.currentCommunity.value!.chapters[0]}/messages");
                            DatabaseReference newMessage =
                                databaseReference.push();
                            String messageId = newMessage.key!;
                            DateTime time = DateTime.now();
                            int epochTime = time.millisecondsSinceEpoch;
                            print("messageId: $messageId");
                            Map<String, dynamic> messageJson = {
                              "from": mainController.currentUser!.uid,
                              "image": imageUrl,
                              "messageId": messageId,
                              "time": epochTime,
                              "type": type
                            };
                            print("Json Form");

                            await newMessage.set(messageJson);
                            print("data upload");
                          } catch (e) {
                            log(e.toString());
                          }
                          // controller.imagePath =
                          //     File.fromRawPath(controller.image.value!).path;
                          // final editorOption = ImageEditorOption();
                          // editorOption.addOption(FlipOption());
                          // editorOption.addOption(ClipOption(height: 400,width: 200));
                          // editorOption.addOption(RotateOption(90));
                          // editorOption.addOption(AddTextOption());
                          // editorOption.outputFormat = OutputFormat.png(88);
                          // print("hello");
                          // controller.image.value =
                          //     await ImageEditor.editFileImage(
                          //         file: image,
                          //         imageEditorOption: editorOption);
                        }
                      }
                    }
                    // XFile? file = await pickImage(ImageSource.gallery);
                    // if (file != null) {
                    //   Uint8List bytes = await file.readAsBytes();
                    //   controller.image.value = bytes;
                    //   var path = await StorageMethods.saveImageToCache(
                    //       bytes,
                    //       "${Uuid().v1()}.${file.path.split('.').last}");
                    //   controller.imagePath = path;
                    // }
                  } catch (e) {
                    log(e.toString());
                  }
                  controller.selectedButton.value = -1;
                  //
                }),
                buildInkWell(
                    'assets/images/document1.svg',
                    'assets/images/document-text_unselected.svg',
                    Color(0xFFFFCE59),
                    2, () async {
                  controller.selectedButton.value = 2;
                  try {
                    controller.documentPath = await pickDocument();
                    if (controller.documentPath != null) {
                      controller.document.value =
                          File(controller.documentPath!);
                    }
                    // controller.document.value.path;
                    Get.back();
                    // controller.focusNode.requestFocus();
                  } catch (e) {
                    print("Select document error: ");
                    print(e.toString());
                    Get.back();
                  }
                  controller.selectedButton.value = -1;
                }),
                buildInkWell(
                    'assets/images/location.svg',
                    'assets/images/location_unselected.svg',
                    Color(0xFFF5225F),
                    3, () async {
                  controller.selectedButton.value = 3;
                  // Map<String, double>? mp =
                  //     await LocationController().getCoordinates();
                  // if (mp != null) {
                  //   controller.messageController.text =
                  //       mp['latitude'].toString() +
                  //           ' ' +
                  //           mp['longitude'].toString();
                  //   controller.text.value = mp['latitude'].toString() +
                  //       ' ' +
                  //       mp['longitude'].toString();
                  // }
                  // Get.back();
                }),
                buildInkWell(
                    'assets/images/chart.svg',
                    'assets/images/chart_unselected.svg',
                    Color(0xFF60C255),
                    4, () {
                  controller.selectedButton.value = 4;
                  Get.back();
                  Get.to(() => PollsScreen());
                  controller.selectedButton.value = -1;
                }),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget buildInkWell(String selectedIcon, String unselectedIcon,
      Color backgroundColor, int myId, VoidCallback onTap) {
    return Obx(() => Column(
          children: [
            InkWell(
                onTap: onTap,
                child:
                    // controller.selectedButton.value != myId ?
                    Container(
                  padding: EdgeInsets.all(10),
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: controller.selectedButton.value == myId
                          ? Border.all(color: Colors.transparent, width: 2)
                          : Border.all(color: Colors.transparent, width: 2),
                      color: Color(0xFFECECEC)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: SvgPicture.asset(
                        unselectedIcon,
                        fit: BoxFit.contain,
                      )),
                )
                // : Container(
                //     padding: EdgeInsets.all(4),
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         // border: Border.all(color: Colors.grey),
                //         color: backgroundColor),
                //     child: Container(
                //       padding: EdgeInsets.all(10),
                //       height: 50,
                //       width: 50,
                //       margin: EdgeInsets.symmetric(vertical: 8.0),
                //       decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           border: controller.selectedButton.value == myId
                //               ? Border.all(color: Colors.white, width: 2)
                //               : Border.all(
                //                   color: Colors.transparent, width: 2),
                //           color: backgroundColor),
                //       child: ClipRRect(
                //           borderRadius: BorderRadius.circular(12.0),
                //           child: SvgPicture.asset(
                //             selectedIcon,
                //             fit: BoxFit.contain,
                //           )),
                //     ),
                //   ),
                ),
            Text(option[myId - 1])
          ],
        ));
  }

  Future<void> deleteData(String nodePath, String key) async {
    try {
      // Construct the path to the node where you want to delete the data
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      String path = '$nodePath/$key';

      // Get a reference to the specific node
      DatabaseReference nodeReference = databaseReference.child(path);

      // Delete the data
      await nodeReference.remove();

      print('Data deleted successfully from path: $path');
    } catch (error) {
      print('Error deleting data: $error');
    }
  }

  _openReportDialogBox() {
    Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text(
            'Report Aman Gairola?',
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 24,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        content: Text(
          'This message will be forwarded to communtiy admin. This contact will not be notified.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF546881),
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w400,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Get.to(() => ReportScreen());
              },
              child: Text(
                'Report',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF665EE0)),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Block this user',
                style: TextStyle(color: Color(0xFF665EE0)),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(
                      BorderSide(color: Color(0xFF665EE0)))),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF665EE0)),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible:
          true, // Set this to true if you want to close dialog by tapping outside
    );
  }

  _openDeleteDialogBox() {
    Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text(
            'Confirm Deletion',
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 24,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        content: Text(
          'Are you sure you want to delete this message?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF546881),
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w400,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          SizedBox(
            width: 120,
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: TextButton(
              onPressed: () async {
                // Perform deletion logic here
                Get.back(); // Close the dialog
                EasyLoading.show(status: "Deleting...");
                print("Hey");
                for (var messageId in controller.selectedMessage) {
                  print(messageId);
                  deleteData(
                      "${mainController.currentCommunityId}/${mainController.currentCommunity.value!.chapters[0]}/messages",
                      messageId);
                }
                controller.selectedMessage.clear();
                EasyLoading.dismiss();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF665EE0)),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible:
          true, // Set this to true if you want to close dialog by tapping outside
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    log("build");
    final DatabaseReference _messagesRef = FirebaseDatabase.instance
        .reference()
        .child(
            "${mainController.currentCommunityId}/${mainController.currentCommunity.value!.chapters[0]}/messages");
    return GestureDetector(
      onTap: () {
        controller.focusNode.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          if (controller.selectedMessage.length > 0) {
            controller.emojiVisible.value = "";
            controller.selectedMessage.clear();
            return false;
          } else if (controller.document.value != null) {
            controller.document.value = null;
            controller.documentPath = null;
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Obx(
              () => Text(
                controller.selectedMessage.length > 0
                    ? "${controller.selectedMessage.length}"
                    : "#General",
                style: TextStyle(color: Colors.white),
              ),
            ),
            leading: Obx(() {
              if (controller.selectedMessage.length > 0) {
                return IconButton(
                    onPressed: () {
                      controller.emojiVisible.value = "";
                      controller.selectedMessage.clear();
                      // controller.totalSelected.value = 0;
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ));
              } else {
                return IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ));
              }
            }),
            actions: [
              Obx(
                () => controller.selectedMessage.length > 0
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.star_outline_rounded,
                            color: Colors.white))
                    : IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.tag, color: Colors.white)),
              ),
              Obx(
                () => controller.selectedMessage.length > 0
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.copy, color: Colors.white))
                    : IconButton(
                        onPressed: () {},
                        icon:
                            Icon(Icons.push_pin_rounded, color: Colors.white)),
              ),
              Obx(
                () => controller.selectedMessage.length > 0
                    ? IconButton(
                        onPressed: () {
                          _openDeleteDialogBox();
                        },
                        icon: Icon(Icons.delete_outline, color: Colors.white))
                    : IconButton(
                        onPressed: () {
                          Get.to(() => MembersScreen());
                        },
                        icon: Icon(Icons.people, color: Colors.white)),
              ),
              Obx(() {
                if (controller.selectedMessage.length > 0) {
                  return PopupMenuButton(
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    color: Colors.black,
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'reply',
                        child: Row(
                          children: [
                            Icon(
                              Icons.tag,
                              color: Colors.white,
                            ),
                            Text(
                              'Reply in thread',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(
                              Icons.report,
                              color: Colors.white,
                            ),
                            Text(
                              'Report',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (String value) {
                      // Perform actions based on selected value
                      if (value == 'reply') {
                        print('Reply in thread selected');
                        // Add your reply in thread logic here
                      } else if (value == 'report') {
                        _openReportDialogBox();
                        print('Report selected');
                        // Add your report logic here
                      }
                    },
                  );
                } else {
                  return PopupMenuButton(
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    color: Colors.black,
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'Announcement',
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/campaign.svg"),
                            Text(
                              ' Announcement',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Media and Links',
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/gallery.svg"),
                            Text(
                              ' Media and Links',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Search Message',
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/search-normal.svg"),
                            Text(
                              ' Search Message',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Mute Notifications',
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/volume-cross.svg"),
                            Text(
                              ' Mute Notifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Clear Chat',
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/trash.svg"),
                            Text(
                              ' Clear Chat',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (String value) {
                      // Perform actions based on selected value
                      if (value == 'Media and Links') {
                        Get.to(() => MediaAndLinksScreen());
                        // Add your reply in thread logic here
                      } else if (value == 'report') {
                        _openReportDialogBox();
                        print('Report selected');
                        // Add your report logic here
                      }
                    },
                  );
                }
              })
            ],
          ),
          body: StreamBuilder(
            stream: _messagesRef.onValue,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.active) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List<dynamic> messages =
                      snapshot.data!.snapshot.children.toList();
                  int n = messages.length;
                  return ListView.builder(
                      // shrinkWrap: true,
                      // primary: false,
                      cacheExtent: double.maxFinite,
                      reverse: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: messages.length,
                      itemBuilder: ((context, index) {
                        // return Text("HI");
                        print(messages[index]);
                        return MessageCard(
                          index: n - 1 - index,
                          messages: messages,
                        );
                      }));
                  // return Obx(
                  //   () => SingleChildScrollView(
                  //     child: Column(
                  //       children: [
                  //         ListView.builder(
                  //             shrinkWrap: true,
                  //             primary: false,
                  //             itemCount: messages.length,
                  //             itemBuilder: ((context, index) {
                  //               return MessageCard(
                  //                 index: index,
                  //                 messages: messages,
                  //               );
                  //             })),
                  //         SizedBox(
                  //           height: 10,
                  //         ),
                  //         if (controller.isImageUploading.value &&
                  //             controller.image.value != null)
                  //           Container(
                  //             height: 200,
                  //             width: 200,
                  //             decoration: BoxDecoration(
                  //                 image: DecorationImage(
                  //                     image: MemoryImage(controller.image.value!),
                  //                     fit: BoxFit.cover),
                  //                 borderRadius: BorderRadius.circular(30)),
                  //             child: Center(child: CircularProgressIndicator()),
                  //           )
                  //       ],
                  //     ),
                  //   ),
                  // );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
          ),

          // body: Obx(
          //   () => ListView.builder(
          //     itemCount: controller.messages.length,
          //     itemBuilder: (context, index) {
          //       return MessageCard(
          //         index: index,
          //       );
          //     },
          //   ),
          // ),

          bottomNavigationBar: controller.isRecording.value
              ? SizedBox.shrink()
              : Container(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 18, right: 18),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        print("Hello ${controller.reply.toString()}");
                        if (controller.reply["name"] == null) {
                          return Container();
                        } else {
                          return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFF9FAFB),
                              ),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(children: [
                                      CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              controller.reply["profileUrl"]),
                                          radius: 14),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(controller.reply["name"]),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            controller.reply.value = {};
                                          },
                                          icon: Icon(Icons.cancel)),
                                    ]),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      controller.reply["textMessage"],
                                      style: TextStyle(
                                        color: Color(0xFF090B0E),
                                        fontSize: 14,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.20,
                                      ),
                                    ),
                                  ]));
                        }
                      }),
                      Obx(
                        () => Container(
                          height: kToolbarHeight + 5,
                          child: Row(
                            children: [
                              Obx(() {
                                if(controller.isLocked.value){
                                  return SizedBox.shrink();
                                }
                                else if (!controller
                                        .isCompleteAudioRecording.value &&
                                    !controller.isRecording.value) {
                                  return IconButton(
                                      onPressed: () {
                                        _openBottomSheet(context);
                                      },
                                      icon: Icon(Icons.add_circle_outlined));
                                } else {
                                  return Container(
                                    width: 40,
                                  );
                                }
                              }),
                              SizedBox(
                                width: 12,
                              ),
                              Visibility(
                                visible: !controller.isLocked.value,
                                replacement: SizedBox.shrink(),
                                child: Expanded(
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: (controller.isRecording.value &&
                                              !controller.isLocked.value)
                                          ? Border.all(color: Colors.transparent)
                                          : Border.all(color: Colors.grey),
                                      color: controller.isRecording.value
                                          ? Colors.transparent
                                          : Color(0xFFF9FAFB),
                                    ),
                                    child: controller
                                            .isCompleteAudioRecording.value
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(formatDuration(Duration(
                                                  seconds:
                                                      controller.seconds.value))),
                                              TextButton(
                                                onPressed: () {
                                                  controller
                                                      .isCompleteAudioRecording
                                                      .value = false;
                                                  controller.seconds.value = 0;
                                                  controller.isRecording.value =
                                                      false;
                                                  File(controller.audioPath!)
                                                      .delete();
                                                },
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              )
                                            ],
                                          )
                                        : controller.isRecording.value
                                            ? controller.isLocked.value
                                                ? Container(
                                                    height: 50,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SvgPicture.asset(
                                                            "assets/images/record.svg"),
                                                        Text(formatDuration(
                                                            Duration(
                                                                seconds:
                                                                    controller
                                                                        .seconds
                                                                        .value))),
                                                      ],
                                                    ),
                                                  )
                                                : Container()
                                            : TextFormField(
                                                focusNode: controller.focusNode,
                                                // autofocus: true,
                                                controller:
                                                    controller.messageController,
                                                decoration: InputDecoration(
                                                  hintText: "Write a Message",
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: (val) {
                                                  controller.emojiVisible.value =
                                                      "";
                                                  controller.selectedMessage
                                                      .clear();
                                                  controller.text.value = val;
                                                },
                                                style: TextStyle(fontSize: 14),
                                              ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Obx(() {
                                return (controller.text.value.trim() != "" ||
                                        controller.image.value != null ||
                                        controller.video.value != null ||
                                        controller.document.value != null)
                                    ? InkWell(
                                        onTap: () async {
                                          Workmanager().cancelAll();
                                          MainController mainController =
                                              Get.find();
                                          print(controller.reply);
                                          String text =
                                              controller.messageController.text;
                                          controller.messageController.text =
                                              "";
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          print(
                                              "\n\n cache imagePath: ${controller.imagePath}");
                                          print(
                                              "cache videoPath: ${controller.videoPath}");
                                          print(
                                              "cache documentPath: ${controller.documentPath} \n\n");
                                          Map<String, dynamic> reply =
                                              controller.reply.value;
                                          controller.reply.value = {};
                                          if (controller.imagePath != null) {
                                            print("image");
                                            controller.isImageUploading.value =
                                                true;
                                            await Workmanager()
                                                .registerOneOffTask(Uuid().v1(),
                                                    Constants.chatImageUpload,
                                                    constraints: Constraints(
                                                        networkType: NetworkType
                                                            .connected),
                                                    inputData: {
                                                  "imagePath":
                                                      controller.imagePath,
                                                  "text": text,
                                                  "uid": mainController
                                                      .currentUser!.uid,
                                                  "communityId": mainController
                                                      .currentCommunityId,
                                                  "chapterId": mainController
                                                      .currentCommunity
                                                      .value!
                                                      .chapters[0]
                                                }).whenComplete(() {
                                              print("jio");
                                              controller.isImageUploading
                                                  .value = false;
                                              controller.image.value = null;
                                              controller.imagePath = null;
                                            });
                                          } else if (controller.videoPath !=
                                              null) {
                                            controller.video.value = null;
                                            print("video");
                                            await Workmanager()
                                                .registerOneOffTask(Uuid().v1(),
                                                    Constants.chatVideoUpload,
                                                    constraints: Constraints(
                                                        networkType: NetworkType
                                                            .connected),
                                                    inputData: {
                                                  "videoPath":
                                                      controller.videoPath,
                                                  "text": text,
                                                  "uid": mainController
                                                      .currentUser!.uid,
                                                  "communityId": mainController
                                                      .currentCommunityId,
                                                  "chapterId": mainController
                                                      .currentCommunity
                                                      .value!
                                                      .chapters[0]
                                                });
                                            controller.videoPath = null;
                                          } else if (controller.documentPath !=
                                              null) {
                                            print("document");
                                            controller.document.value = null;

                                            await Workmanager()
                                                .registerOneOffTask(
                                                    Uuid().v1(),
                                                    Constants
                                                        .chatDocumentUpload,
                                                    constraints: Constraints(
                                                        networkType: NetworkType
                                                            .connected),
                                                    inputData: {
                                                  "documentPath":
                                                      controller.documentPath,
                                                  "text": text,
                                                  "uid": mainController
                                                      .currentUser!.uid,
                                                  "communityId": mainController
                                                      .currentCommunityId,
                                                  "chapterId": mainController
                                                      .currentCommunity
                                                      .value!
                                                      .chapters[0]
                                                });
                                            controller.documentPath = null;
                                            print("Hey");
                                          } else if (controller.text.value !=
                                              "") {
                                            print("text");
                                            final DatabaseReference
                                                databaseReference =
                                                FirebaseDatabase.instance
                                                    .ref()
                                                    .child(
                                                        "${mainController.currentCommunityId}/${mainController.currentCommunity.value!.chapters[0]}/messages");
                                            DatabaseReference newMessage =
                                                await databaseReference.push();
                                            String messageId = newMessage.key!;
                                            DateTime time = DateTime.now();
                                            int epochTime =
                                                time.millisecondsSinceEpoch;
                                            Map<String, dynamic> messageJson = {
                                              "from": mainController
                                                  .currentUser!.uid,
                                              "messageId": messageId,
                                              "text": controller.text.value,
                                              "time": epochTime,
                                              "type": "TEXT"
                                            };
                                            print("Json Form text");
                                            await newMessage.set(messageJson);
                                          }
                                          print("Hiiii..");
                                          controller.text.value = "";
                                        },
                                        child: Container(
                                          width: 30,
                                          child: SvgPicture.asset(
                                              "assets/images/send.svg",
                                              fit: BoxFit.fitWidth),
                                        ),
                                      )
                                    : Expanded(
                                      flex: controller.isLocked.value ? 1 : 0,
                                      child: RecordButton(
                                          controller:
                                              controller.animationController,
                                          lockController:
                                              controller.lockController,
                                        ),
                                    );
                              })
                              // GestureDetector(
                              //   onTap: () async {
                              //     if (controller.isCompleteAudioRecording.value) {
                              //       String filename = recordFilePath!.split('/').last;
                              //       Duration audioLen =
                              //           controller.end!.difference(controller.start!);
                              //       int audioLength = audioLen.inMilliseconds;
                              //       controller.isCompleteAudioRecording.value = false;
                              //       controller.isRecording.value = false;
                              //       await Workmanager().registerOneOffTask(
                              //           Uuid().v1(), Constants.chatAudioUpload,
                              //           constraints: Constraints(
                              //               networkType: NetworkType.connected),
                              //           inputData: {
                              //             "audioPath": recordFilePath,
                              //             "audioLen": audioLength
                              //           });
                              //       // print("audio path: ${recordFilePath}");
                              //       // File file = File(recordFilePath!);
                              //       // print((await file.length()).toString());
                              //       // String uid = Uuid().v1();
                              //       // Duration audioLen =
                              //       //     controller.end!.difference(controller.start!);
                              //       // String audioMessageUrl =
                              //       //     await StorageMethods.uploadDocument(
                              //       //         'chat/audio', uid, file);
                              //       // print("audio Message Url: $audioMessageUrl");
                              //       // controller.messages.add(RxMap({
                              //       //   'profileUrl':
                              //       //       'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80',
                              //       //   'name': 'Pankaj',
                              //       //   'imageUrl': null,
                              //       //   'documentUrl': null,
                              //       //   'audioMessageUrl': audioMessageUrl,
                              //       //   'audioLen': audioLen,
                              //       //   'textMessage': controller.messageController.text,
                              //       //   'repliedMessage': null,
                              //       //   'date': DateTime.now(),
                              //       //   'prevDate':
                              //       //       DateTime.now().subtract(Duration(minutes: 2)),
                              //       //   'owner': true,
                              //       //   "isSelected": false
                              //       // }));
                              //     }
                              //   },
                              //   onLongPress: () async {
                              //     startRecord();
                              //   },
                              //   onLongPressEnd: (details) {
                              //     stopRecord();
                              //   },
                              //   child: Container(
                              //       padding: EdgeInsets.all(8.86),
                              //       // margin: EdgeInsets.symmetric(horizontal: 4),
                              //       height: 40.45459,
                              //       width: 40.45459,
                              //       decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(30),
                              //           color: Color(0xFF7B61FF)),
                              //       child: controller.isCompleteAudioRecording.value
                              //           ? Icon(
                              //               Icons.send,
                              //               color: Colors.white,
                              //             )
                              //           : controller.isRecording.value
                              //               ? Icon(
                              //                   Icons.stop,
                              //                   color: Colors.red,
                              //                 )
                              //               : Container(
                              //                 height: 22.73725,
                              //                 width: 22.73725,
                              //                   child: SvgPicture.asset(
                              //                     "assets/images/microphone-2.svg",
                              //                     fit: BoxFit.contain,
                              //                   ),
                              //                 )),
                              // ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

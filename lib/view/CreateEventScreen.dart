import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/controllers/CreatedEventController.dart';
import 'package:custard_flutter/controllers/MainController.dart';
import 'package:custard_flutter/utils/utils.dart';
import 'package:custard_flutter/view/AddHostScreen.dart';
import 'package:custard_flutter/view/SellingTicketScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends StatelessWidget {
  CreateEventScreen({super.key});
  final controller = Get.put(CreatedEventController());
  MainController mainController = Get.find();
  DateTime date = DateTime.now();
  FocusNode priceFocusNode = FocusNode();
  FocusNode capacityFocusNode = FocusNode();

  void onPopBack() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Are You Sure',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Do you want to go back?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF546881),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          Container(
            width: 120,
            child: TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text(
                'No',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF665EE0),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            width: 120,
            child: TextButton(
              onPressed: () {
                EasyLoading.dismiss();
                Get.back(); // Close the dialog
                Get.back();
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xFF665EE0))),
              child: Text(
                'Yes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _openStartDateTimePicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Start Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            Divider(),
            Container(
              height: 300,
              child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                  onDateChanged: (data) {
                    date = data;
                  }),
            ),
            CustardButton(
              onPressed: () async {
                // controller.isDate.value = false;
                TimeOfDay? time;
                time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (time != null) {
                  // controller.isDate.value = true;
                  controller.startTime = time;
                  controller.startDate = date;
                  Get.back();
                  _openEndDateTimePicker(context);
                }
              },
              buttonType: ButtonType.POSITIVE,
              label: "Next",
              backgroundColor: Color(0xFF7B61FF),
              textColor: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _openEndDateTimePicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select End Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            Divider(),
            Container(
              height: 300,
              child: CalendarDatePicker(
                  initialDate: controller.startDate,
                  firstDate: controller.startDate,
                  lastDate: DateTime(2101),
                  onDateChanged: (data) {
                    date = data;
                  }),
            ),
            CustardButton(
              onPressed: () async {
                // controller.isDate.value = false;
                TimeOfDay? time;
                time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (time != null) {
                  controller.isDate.value = true;
                  controller.endTime = time;
                  controller.endDate = date;
                  Get.back();
                }
              },
              buttonType: ButtonType.POSITIVE,
              label: "Next",
              backgroundColor: Color(0xFF7B61FF),
              textColor: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onPopBack();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              "Create Event",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            leading: IconButton(
                onPressed: () {
                  onPopBack();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            actions: [
              PopupMenuButton(
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  color: Colors.black,
                  itemBuilder: ((context) => [
                        PopupMenuItem<String>(
                          value: 'Delete Event',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                ' Delete Event',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      ]))
            ]),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. Image with Rounded Border and Camera Icon
              Obx(
                () => Stack(
                  children: [
                    GestureDetector(
                      onTap: controller.image.value != null
                          ? null
                          : () async {
                              XFile? file =
                                  await pickImage(ImageSource.gallery);
                              if (file != null) {
                                final path = file.path;
                                CroppedFile? croppedFile =
                                    await ImageCropper().cropImage(
                                  sourcePath: path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,
                                  ],
                                  uiSettings: [
                                    AndroidUiSettings(
                                        toolbarTitle: 'Edit',
                                        toolbarColor: Colors.black,
                                        toolbarWidgetColor: Colors.white,
                                        initAspectRatio:
                                            CropAspectRatioPreset.square,
                                        lockAspectRatio: true),
                                    IOSUiSettings(
                                      title: 'Edit',
                                    ),
                                    // WebUiSettings(
                                    //   context: context,
                                    // ),
                                  ],
                                );
                                if (croppedFile != null) {
                                  controller.image.value =
                                      await croppedFile.readAsBytes();
                                }
                              }
                            },
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 18, vertical: 16),
                          width: Get.size.width * 0.5,
                          height: Get.size.width * 0.5,
                          decoration: BoxDecoration(
                            image: controller.image.value != null
                                ? DecorationImage(
                                    image: MemoryImage(controller.image.value!),
                                    fit: BoxFit.cover)
                                : null,
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: controller.image.value == null
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Change event poster',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.image.value != null,
                      child: Positioned(
                          bottom: 0,
                          right: Get.size.width * 0.17,
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 252, 232, 232),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                                onPressed: () async {
                                  XFile? file =
                                      await pickImage(ImageSource.gallery);
                                  if (file != null) {
                                    final path = file.path;
                                    CroppedFile? croppedFile =
                                        await ImageCropper().cropImage(
                                      sourcePath: path,
                                      aspectRatioPresets: [
                                        CropAspectRatioPreset.square,
                                      ],
                                      uiSettings: [
                                        AndroidUiSettings(
                                            toolbarTitle: 'Edit',
                                            toolbarColor: Colors.black,
                                            toolbarWidgetColor: Colors.white,
                                            initAspectRatio:
                                                CropAspectRatioPreset.square,
                                            lockAspectRatio: true),
                                        IOSUiSettings(
                                          title: 'Edit',
                                        ),
                                        // WebUiSettings(
                                        //   context: context,
                                        // ),
                                      ],
                                    );
                                    if (croppedFile != null) {
                                      controller.image.value =
                                          await croppedFile.readAsBytes();
                                    }
                                  }
                                },
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.black,
                                )),
                          )),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.0),

              // 3. Bold Text 'The Art of Living'
              TextField(
                controller: controller.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "Add Event Name",
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                ),
              ),

              SizedBox(height: 16.0),
              Divider(),
              // 4. Bold Text 'Event Description'
              SizedBox(height: 16.0),
              // 6. Two Rows with Icon and Text
              GestureDetector(onTap: () {
                _openStartDateTimePicker(context);
              }, child: Obx(() {
                if (!controller.isDate.value) {
                  return buildRowWithIcon(
                      Icons.calendar_month, 'Select Date and Time', '');
                } else {
                  return buildRowWithIcon(
                      Icons.calendar_month,
                      DateFormat('EEEE, MMMM d, yyyy')
                          .format(controller.startDate),
                      "${controller.formatTimeOfDay(controller.startTime)} - ${controller.formatTimeOfDay(controller.endTime)}");
                }
              })),
              SizedBox(
                height: 24,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: Color(0xFFF2EFFF),
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.location_on, color: Color(0xFF665EE0)),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    width: 200,
                    child: TextFormField(
                      style: TextStyle(
                        color: Color(0xFF090B0E),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter Location",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFF090B0E),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // buildRowWithIcon(Icons.location_on, '2, Jawahar Lal Nehru Marg',
              //     '10:00 AM - 09:00PM'),

              // Obx(
              //   () => SwitchListTile(
              //     value: controller.isApproved.value,
              //     onChanged: (val) {
              //       controller.isApproved.value = val;
              //     },
              //     title: Text(
              //       'Approval required',
              //       style: TextStyle(
              //         color: Color(0xFF546881),
              //         fontSize: 14,
              //         fontFamily: 'Inter',
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),

              // SizedBox(height: 16.0),
              Divider(),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ticket price',
                        style: TextStyle(
                          color: Color(0xFF141414),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Color(0xFFF2EFFF),
                                borderRadius: BorderRadius.circular(8)),
                            child: SvgPicture.asset(
                              "assets/images/wallet-minus.svg",
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Obx(() {
                            if (controller.isFreeEvent.value) {
                              return Container();
                            } else {
                              return Text(
                                '₹ ',
                                style: TextStyle(
                                  color: Color(0xFF090B0E),
                                  fontSize: 14,
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }
                          }),
                          Container(
                              width: 100,
                              height: 50,
                              alignment: Alignment.centerLeft,
                              child: Obx(() {
                                if (controller.isFreeEvent.value) {
                                  return InkWell(
                                    onTap: (){
                                      controller.isFreeEvent.value = false;
                                      priceFocusNode.requestFocus();
                                    },
                                    child: Text(
                                      "Free Event",
                                      style: TextStyle(
                                        color: Color(0xFF090B0E),
                                        fontSize: 14,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }
                                return TextField(
                                  focusNode: priceFocusNode,
                                  controller: controller.price,
                                  style: TextStyle(
                                    color: Color(0xFF090B0E),
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                      hintText: "Add price",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none),
                                  keyboardType: TextInputType.number,
                                );
                              })),
                        ],
                      ),
                      Container(
                          width: 170,
                          child: Obx(
                            () => SwitchListTile(
                              value: controller.isFreeEvent.value,
                              onChanged: (val) {
                                controller.isFreeEvent.value = val;
                              },
                              title: Text(
                                'Free event',
                                style: TextStyle(
                                  color: Color(0xFF546881),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Capacity',
                        style: TextStyle(
                          color: Color(0xFF141414),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                                color: Color(0xFFF2EFFF),
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.people, color: Color(0xFF665EE0)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              width: 100,
                              height: 50,
                              alignment: Alignment.centerLeft,
                              child: Obx(() {
                                if (controller.isRemoveLimit.value) {
                                  return InkWell(
                                    onTap: (){
                                      controller.isRemoveLimit.value=false;
                                      capacityFocusNode.requestFocus();
                                    },
                                    child: Text(
                                      "No Limit",
                                      style: TextStyle(
                                        color: Color(0xFF090B0E),
                                        fontSize: 14,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }
                                return TextField(
                                  focusNode: capacityFocusNode,
                                  controller: controller.capacity,
                                  style: TextStyle(
                                    color: Color(0xFF090B0E),
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                      hintText: "Add Capacity",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none),
                                  keyboardType: TextInputType.number,
                                );
                              })),
                        ],
                      ),
                      Container(
                          width: 190,
                          child: Obx(
                            () => SwitchListTile(
                              value: controller.isRemoveLimit.value,
                              onChanged: (val) {
                                controller.isRemoveLimit.value = val;
                              },
                              title: Text(
                                'Remove limit',
                                style: TextStyle(
                                  color: Color(0xFF546881),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Divider(),
              SizedBox(
                height: 16,
              ),
              Text(
                'Event description',
                style: TextStyle(
                  color: Color(0xFF141414),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 8.0),

              // 5. Text Description
              TextField(
                controller: controller.description,
                style: TextStyle(
                  color: Color(0xFF546881),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "Enter the event description here...",
                  hintStyle: TextStyle(
                    color: Color(0xFF909DAD),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              Divider(),
              GestureDetector(
                onTap: () {
                  Get.to(() => SellingTicketScrenn());
                },
                child: buildRowWithIcon(
                    const IconData(0xe040, fontFamily: 'MaterialIcons'),
                    'Add Payment Options',
                    'UPI/Bank Account/ PayPal'),
              ),

              SizedBox(height: 16.0),

              // 8. Bold Text 'Hosted By'
              Text('Hosted By',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

              SizedBox(height: 8.0),

              // 9. ListView Builder with Horizontal Scroll Direction
              Container(
                  height: 120.0,
                  child: Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.hosted.length +
                          2, // Replace with your actual item count
                      itemBuilder: (context, index) {
                        if (index == controller.hosted.length + 1) {
                          // Last item with + icon and text
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => AddHostScreen());
                                    // controller.hosted.add({
                                    //   "name": "Pankaj",
                                    //   "image": "url",
                                    // });
                                  },
                                  child: CircleAvatar(
                                    radius: 35.0,
                                    backgroundColor: Color(0xFFF2EFFF),
                                    child: Icon(Icons.add,
                                        color: Color(0xFF7B61FF)),
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Invite Person',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage: CachedNetworkImageProvider(
                                      mainController.currentUser!.profilePic),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  mainController.currentUser!.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Other items with circular image and name
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage: NetworkImage(
                                      "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Sonu',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  )),

              SizedBox(height: 16.0),

              // 10. Bold Text 'Theme'
              Text(
                'Theme',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 18,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                height: 100,
                child: ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Title',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF090B0E),
                                fontSize: 12,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text('Abstract')
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustardButton(
                onPressed: () async {
                  try {
                    EasyLoading.show(status: "Loading...");
                    await controller
                        .createEvent(mainController.currentCommunityId!);
                  } catch (e) {
                    print("error Post Event: ${e}");
                  }
                  EasyLoading.dismiss();
                  Get.back();
                },
                buttonType: ButtonType.POSITIVE,
                label: "Create Event",
                backgroundColor: Color(0xFF7B61FF),
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedRectChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const RoundedRectChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      margin: EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 4.0),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              height: 0.11,
              letterSpacing: 0.20,
            ),
          )
        ],
      ),
    );
  }
}

// Widget for Rounded Image
class RoundedImage extends StatelessWidget {
  final String imageUrl;

  const RoundedImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      width: double.infinity,
      height: 120.0,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}

// Function to build Row with Icon and Text
Widget buildRowWithIcon(IconData icon, String labelText, String normalText) {
  return Row(
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            color: Color(0xFFF2EFFF), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Color(0xFF665EE0)),
      ),
      SizedBox(width: 8.0),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 16,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            normalText,
            style: TextStyle(
              color: Color(0xFF546881),
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  );
}

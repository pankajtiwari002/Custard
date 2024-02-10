import 'dart:developer';

import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/controllers/ManageEventController.dart';
import 'package:custard_flutter/view/CancelEventScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';

class EditEventsScreen extends StatelessWidget {
  final snapshot;
  int index;
  EditEventsScreen({super.key, required this.snapshot, required this.index});

  ManageEventController controller = Get.find();
  DateTime date = DateTime.now();
  FocusNode priceFocusNode = FocusNode();
  FocusNode capacityFocusNode = FocusNode();

  DateTime convertMillisecondsToDateTime(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
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

  void _showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete',
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
              'Are you sure you want to delete this event?',
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
                // Add your 'Yes' button logic here
              },
              child: Text(
                'Yes',
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
                Get.back(); // Close the dialog
                // Add your 'No' button logic here
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xFF665EE0))),
              child: Text(
                'No',
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Event",
            style: TextStyle(color: Colors.white),
          ),
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
            PopupMenuButton(
                child: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                color: Colors.black,
                itemBuilder: ((context) => [
                      PopupMenuItem<String>(
                        value: 'UnPublish Event',
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility_off,
                              color: Colors.white,
                            ),
                            Text(
                              ' UnPublish Event',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        onTap: () {
                          Get.to(() => CancelEventScreen());
                        },
                        value: 'Cancel Event',
                        child: Row(
                          children: [
                            Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                            Text(
                              ' Cancel Event',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        onTap: () {
                          _showDeleteDialog();
                        },
                        value: 'Delete Event',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                            ),
                            Text(
                              ' Delete Event',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ])),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),

              // 2. Image with Rounded Border and Camera Icon
              Obx(
                () => Stack(
                  children: [
                    Center(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        width: Get.size.width * 0.5,
                        height: Get.size.width * 0.5,
                        decoration: BoxDecoration(
                          image: controller.image.value == null
                              ? DecorationImage(
                                  image: NetworkImage(snapshot[index]
                                      ['coverPhotoUrl']),
                                  fit: BoxFit.cover)
                              : DecorationImage(
                                  image: MemoryImage(controller.image.value!)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    Positioned(
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
                  ],
                ),
              ),

              SizedBox(height: 16.0),

              // 3. Bold Text 'The Art of Living'
              TextFormField(
                controller: controller.titleController,
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
              TextFormField(
                controller: controller.descriptionController,
                // initialValue: controller.data["description"],
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

              // 6. Two Rows with Icon and Text
              GestureDetector(onTap: () {
                _openStartDateTimePicker(context);
              }, child: Obx(() {
                if (!controller.isDate.value) {
                  return buildRowWithIcon(
                  Icons.calendar_month,
                  DateFormat('EEEE, MMMM d').format(
                      convertMillisecondsToDateTime(
                          snapshot[index]['dateTime'])),
                  "${DateFormat.jm().format(convertMillisecondsToDateTime(snapshot[index]['dateTime']))} - ${DateFormat.jm().format(convertMillisecondsToDateTime(snapshot[index]['dateTime']))}");
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

              SizedBox(height: 16.0),

              // 7. Image with Rounded Border
              RoundedImage(
                  imageUrl:
                      "https://www.mapsofindia.com/maps/rajasthan/tehsil/chittaurgarh-tehsil-map.jpg"),

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
                                    onTap: () {
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
                onPressed: () async{
                  EasyLoading.show(status: "updating...");
                  try {
                    await controller.updateEvent();
                  } catch (e) {
                    log(e.toString());
                  }
                  EasyLoading.dismiss();
                  Get.back(result: true);
                },
                buttonType: ButtonType.POSITIVE,
                label: "Save Changes",
                backgroundColor: Color(0xFF7B61FF),
                textColor: Colors.white,
              )
            ],
          ),
        ));
  }
}

// Widget for Rounded Rectangle Chip
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
              height: 0,
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

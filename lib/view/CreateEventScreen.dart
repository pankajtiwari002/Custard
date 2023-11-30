import 'dart:typed_data';

import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventScreen extends StatelessWidget {
  CreateEventScreen({super.key});

  Rx<Uint8List?> image = Rxn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Create Event",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {},
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
            // 1. Scrollable Row with Rounded Rectangel Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Your rounded rectangle chips with icon and text
                  RoundedRectChip(icon: Icons.message, label: 'Invite Guest'),
                  RoundedRectChip(
                      icon: Icons.announcement, label: 'Send Announcement'),
                  // ...
                ],
              ),
            ),

            SizedBox(height: 16.0),

            // 2. Image with Rounded Border and Camera Icon
            Obx(
              () => Container(
                margin: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  image: image.value != null
                      ? DecorationImage(
                          image: MemoryImage(image.value!), fit: BoxFit.cover)
                      : null,
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () async {
                          XFile? file = await pickImage(ImageSource.gallery);
                          if (file != null) {
                            image.value = await file.readAsBytes();
                          }
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        )),
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
                ),
              ),
            ),

            SizedBox(height: 16.0),

            // 3. Bold Text 'The Art of Living'
            TextField(
              showCursor: false,
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
            TextField(
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
            SizedBox(height: 16.0),
            // 6. Two Rows with Icon and Text
            buildRowWithIcon(Icons.calendar_month, 'Friday, 17 November',
                '10:00 AM - 09:00PM'),
            SizedBox(
              height: 24,
            ),
            buildRowWithIcon(Icons.location_on, '2, Jawahar Lal Nehru Marg',
                '10:00 AM - 09:00PM'),

            SwitchListTile(
              value: false,
              onChanged: (val) {},
              title: Text(
                'Approval required',
                style: TextStyle(
                  color: Color(0xFF546881),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 16.0),
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
                          decoration: BoxDecoration(
                              color: Color(0xFFF2EFFF),
                              borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.people, color: Color(0xFF665EE0)),
                        ),
                        Text(
                          '  ₹ ',
                          style: TextStyle(
                            color: Color(0xFF090B0E),
                            fontSize: 14,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '200',
                          style: TextStyle(
                            color: Color(0xFF090B0E),
                            fontSize: 14,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 180,
                      child: SwitchListTile(
                        value: false,
                        onChanged: (val) {},
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
                    )
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
                        Text(
                          '  150',
                          style: TextStyle(
                            color: Color(0xFF090B0E),
                            fontSize: 14,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w500,
                            height: 0.08,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 180,
                      child: SwitchListTile(
                        value: false,
                        onChanged: (val) {},
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
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 16,),
            Divider(),
            SizedBox(height: 16,),
            buildRowWithIcon(IconData(0xe040, fontFamily: 'MaterialIcons'),
                'Add Payment Options', 'UPI/Bank Account/ PayPal'),

            SizedBox(height: 16.0),

            // 8. Bold Text 'Hosted By'
            Text('Hosted By',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            SizedBox(height: 8.0),

            // 9. ListView Builder with Horizontal Scroll Direction
            Container(
              height: 120.0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 2, // Replace with your actual item count
                itemBuilder: (context, index) {
                  if (index == 1) {
                    // Last item with + icon and text
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 35.0,
                            backgroundColor: Color(0xFFF2EFFF),
                            child: Icon(Icons.add, color: Color(0xFF7B61FF)),
                          ),
                          SizedBox(height: 4.0),
                          Text('Invite Person', style: TextStyle(fontSize: 12)),
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
                          Text('Sonu', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),

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
            SizedBox(height: 10,),
              CustardButton(
                onPressed: () {},
                buttonType: ButtonType.POSITIVE,
                label: "Create Event",
                backgroundColor: Color(0xFF7B61FF),
                textColor: Colors.white,
              )
          ],
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

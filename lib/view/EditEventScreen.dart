import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/view/CancelEventScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditEventsScreen extends StatelessWidget {
  const EditEventsScreen({super.key});

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
                backgroundColor: MaterialStateProperty.all(Color(0xFF665EE0))
              ),
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
                        onTap: (){
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
                              ' Cancele Event',
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1524601500432-1e1a4c71d692?auto=format&fit=crop&q=80&w=1000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGdyb3VwfGVufDB8fDB8fHww"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        )),
                    Text(
                      'Change cover photo',
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

              SizedBox(height: 16.0),

              // 3. Bold Text 'The Art of Living'
              Text(
                'The Art of Living',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 24,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
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
              Text(
                " Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature's beauty. Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature's beauty.",
                style: TextStyle(
                  color: Color(0xFF546881),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 16.0),

              // 6. Two Rows with Icon and Text
              buildRowWithIcon(Icons.calendar_month, 'Friday, 17 November',
                  '10:00 AM - 09:00PM'),
              SizedBox(
                height: 24,
              ),
              buildRowWithIcon(Icons.location_on, '2, Jawahar Lal Nehru Marg',
                  '10:00 AM - 09:00PM'),

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
                              height: 0.08,
                            ),
                          ),
                          Text(
                            '200',
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

import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/view/BookingScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class RegisterNowScreen extends StatelessWidget {
  final snapshot;
  int index;
  RegisterNowScreen({super.key,required this.snapshot,required this.index});

  DateTime convertMillisecondsToDateTime(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Event Details",style: TextStyle(color: Colors.white),),
        leading: IconButton(onPressed: (){
          Get.back();
        },icon: Icon(Icons.arrow_back_ios,color: Colors.white,),),
        actions: [
          PopupMenuButton(
              color: Colors.black,
              onSelected: (val){
              },
              child: Icon(Icons.more_vert,color: Colors.white),
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  onTap: () async{
                    await Share.share("title : ${snapshot.data.docs[index]['title']}",subject: "hi");
                  },
                  value: 'All Guests',
                  child: Row(
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      Text(
                        '  Share Events',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ])
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    child: Image.network(
                    snapshot.data.docs[index]['coverPhotoUrl'],
                    fit: BoxFit.cover,
                ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        )
                      ),
                    ),
                  )
                ]
              ),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                // height: MediaQuery.of(context).size.height * 0.65,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data.docs[index]['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF090B0E),
                        fontSize: 24,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    buildRowWithIcon(Icons.calendar_month, DateFormat('EEEE, MMMM d')
                        .format(convertMillisecondsToDateTime(snapshot.data.docs[index]['dateTime'])),
                        DateFormat.jm()
                            .format(convertMillisecondsToDateTime(snapshot.data.docs[index]['dateTime']))),
                    SizedBox(
                      height: 24,
                    ),
                    buildRowWithIcon(Icons.location_on, '2, Jawahar Lal Nehru Marg',
                        'Opposite Opp Commerce College, Jhalana Doongri, Jaipur, Rajasthan 302004'),
                    SizedBox(
                      height: 24,
                    ),
                    buildRowWithIcon(Icons.location_on, '₹ ${snapshot.data.docs[index]['ticketPrice']}',
                        ''),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'About',
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
                      snapshot.data.docs[index]['description'],
                      style: TextStyle(
                        color: Color(0xFF546881),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Text(
                      'Direction',
                      style: TextStyle(
                        color: Color(0xFF141414),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // 7. Image with Rounded Border
                    RoundedImage(
                        imageUrl:
                        "https://www.mapsofindia.com/maps/rajasthan/tehsil/chittaurgarh-tehsil-map.jpg"),
                    SizedBox(height: 24.0),
                    Text(
                      'Hosts',
                      style: TextStyle(
                        color: Color(0xFF141414),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.0),

                    // 9. ListView Builder with Horizontal Scroll Direction
                    Container(
                      height: 100.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 2, // Replace with your actual item count
                        itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: NetworkImage(
                                        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text('Sonu', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                color: Color(0xFF141414),
                                fontSize: 16,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'INR ${snapshot.data.docs[index]['ticketPrice']}',
                              style: TextStyle(
                                color: Color(0xFF141414),
                                fontSize: 16,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 150,
                          child: CustardButton(onPressed: (){
                            Get.to(() => BookingScreen(snapshot: snapshot, index: index));
                          }, buttonType: ButtonType.POSITIVE, label: "Book",backgroundColor: Color(0xFF665EE0),),
                        )
                      ]
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}

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
          SizedBox(
            width: 300,
            child: Text(
              normalText,
              style: TextStyle(
                color: Color(0xFF546881),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    ],
  );
}
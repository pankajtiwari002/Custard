import 'package:custard_flutter/view/RegisterNowScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  // String image;
  // String title;
  // int dateTime;
  // String id;
  final snapshot;
  int index;

  EventCard({required this.snapshot, required this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 200,
      child: Card(
        elevation: 1.0,
        margin: EdgeInsets.all(10.0),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Upcoming',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
              Image.network(
                snapshot.data!.docs[index]['coverPhotoUrl'],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100.0,
              ),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    snapshot.data!.docs[index]['title'],
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    '${DateFormat("EEEE").format(DateTime.fromMillisecondsSinceEpoch(snapshot.data!.docs[index]['dateTime']))}, ${DateFormat("dd MMMM, yyyy").format(DateTime.fromMillisecondsSinceEpoch(snapshot.data!.docs[index]['dateTime']))}',
                    style: TextStyle(
                      color: Color(0xFF546881),
                      fontSize: 10,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              Container(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      Get.to(() => RegisterNowScreen(
                            snapshot: snapshot.data!.docs[index].data(),
                            id: snapshot.data!.docs[index].id,
                          ));
                    },
                    child: Text(
                      'EXPLORE',
                      style: TextStyle(
                        color: Color(0xFF7B61FF),
                        fontSize: 12,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

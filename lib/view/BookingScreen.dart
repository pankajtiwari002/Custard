import 'package:custard_flutter/components/CustardButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
  final snapshot;
  int index;
  BookingScreen({super.key,required this.snapshot,required this.index});

  Rx<int> noOfTicket = 0.obs;

  DateTime convertMillisecondsToDateTime(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(snapshot.data.docs[index]['title'],style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),onPressed: (){},),
      ),
      // backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_outline,color: Color(0xFF665EE0),),
                SizedBox(width: 5,),
                Text("Order Summary",style: TextStyle(color: Color(0xFF665EE0)),),
                SizedBox(width: 5,),
                Expanded(child: Divider()),
                SizedBox(width: 5,),
                Icon(Icons.check_circle_outline,color: Color(0xFF665EE0),),
                SizedBox(width: 5,),
                Text("Payment",style: TextStyle(color: Color(0xFF665EE0)),),
              ],
            ),
            SizedBox(height: 24,),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Card(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(snapshot.data.docs[index]['coverPhotoUrl']),fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              snapshot.data.docs[index]['title'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              )
                          ),
                          Row(
                            children: [
                              Icon(Icons.calendar_month,color: Colors.grey),
                              SizedBox(width: 5,),
                              Text(
                                  "${DateFormat("EE d MMM y").format(convertMillisecondsToDateTime(snapshot.data.docs[index]['dateTime']))},"
                                      " ${DateFormat.jm().format(convertMillisecondsToDateTime(snapshot.data.docs[index]['dateTime']))}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  )
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_pin,color: Colors.grey),
                              SizedBox(width: 5,),
                              Text(
                                  "Jawahar Lal Nehru Marg",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  )
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
                "Order summary",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customRow(
                          Text(
                          "Ticket for",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )
                      ), Row(
                        children: [
                          IconButton(onPressed: (){
                            if(noOfTicket.value==0) return;
                            noOfTicket.value--;
                          }, icon: Icon(Icons.add,color: Color(0xFF665EE0),)),
                          Obx(() => Text(noOfTicket.value.toString(),style: TextStyle(fontWeight: FontWeight.w600),),),
                          IconButton(onPressed: (){
                            noOfTicket.value++;
                          }, icon: Icon(Icons.add,color: Color(0xFF665EE0),)),
                        ],
                      )),
                      SizedBox(height: 10,),
                      customRow(Text(
                          "Subtotal",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )
                      ), Text(
                          "Rs 99.00",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )
                      ),),
                      SizedBox(height: 10,),
                      customRow(Text(
                          "Fees",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )
                      ), Text(
                          "Rs 15.00",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )
                      ),),
                      SizedBox(height: 10,),
                      customRow(Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ), Text(
                          "Rs 114.00",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: customRow(Row(
                    children: [
                      Icon(Icons.local_offer,color: Colors.yellowAccent,),
                      Text("  Offers",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
                    ],
                  ), TextButton(onPressed: (){}, child: Text("Apply Now",style: TextStyle(color: Color(0xFF665EE0)),)))
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
        child: CustardButton(onPressed: (){}, buttonType: ButtonType.POSITIVE, label: "Proceed to Pay",backgroundColor: Color(0xFFDDDFE4),),
      ),
    );
  }
}

Widget customRow(Widget label,Widget value){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      label,
      value
    ],
  );
  
}

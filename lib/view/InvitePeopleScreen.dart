import 'package:custard_flutter/components/CustardButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvitePeopleScreen extends StatelessWidget {
  const InvitePeopleScreen({super.key});

  _showMoreBottomSheet() {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        child: Container(
          padding: EdgeInsets.only(bottom: 20,top: 15),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.people,
                  color: Colors.red,
                ),
                title: Text(
                  'Kick Priya Bhatt',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.block,
                  color: Colors.red,
                ),
                title: Text(
                  'Ban Priya Bhatt',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Participants",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          CustardButton(
            buttonType: ButtonType.NEGATIVE,
            label: "+ Invite People",
            onPressed: () {},
            textColor: Colors.purple,
            backgroundColor: Colors.white,
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              itemCount: 8,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80"),
                  ),
                  title: Text("Priya Bhatt"),
                  trailing: IconButton(
                      onPressed: () {
                        _showMoreBottomSheet();
                      },
                      icon: Icon(Icons.more_vert)),
                );
              })
        ],
      ),
    );
  }
}

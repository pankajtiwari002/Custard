import 'package:custard_flutter/view/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MembersScreen extends StatelessWidget {
  _openBottomSheet() {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
            bottom: 5
          ),
          color: const Color.fromRGBO(255, 255, 255, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'More Options',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Add or change role'),
                onTap: () {
                  // Add your logic here for each list tile.
                },
              ),
              ListTile(
                leading: Icon(IconData(0xe6c3, fontFamily: 'MaterialIcons')),
                title: Text('Mute'),
                onTap: () {
                  // Add your logic here for each list tile.
                },
              ),
              ListTile(
                leading: Icon(Icons.block),
                title: Text('Block'),
                onTap: () {
                  // Add your logic here for each list tile.
                },
              ),
              ListTile(
                leading: Icon(Icons.report),
                title: Text('Report'),
                onTap: () {
                  // Add your logic here for each list tile.
                },
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
        title: const Text(
          'Members',
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
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.black),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Search\nmembers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.20,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.black),
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Members\nsetting',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF546881),
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.20,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFF2EFFF)),
                    ),
                    child: Text(
                      '+ Invite people',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF7B61FF),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
              const Text(
                'ADMIN -1 ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF909DAD),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.20,
                ),
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: (){
                      Get.to(() => ProfileScreen(imageUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80"));
                    },
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80"),
                    ),
                    title: Text(
                      'Ravi Shastri',
                      style: TextStyle(
                        color: Color(0xFF090B0E),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Living my best life.',
                      style: TextStyle(
                        color: Color(0xFF909DAD),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: () {}, icon: Icon(Icons.more_horiz)),
                  );
                },
              ),
              Text(
                'SCHOOL -1 ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF909DAD),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.20,
                ),
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80"),
                    ),
                    title: Text(
                      'Ravi Shastri',
                      style: TextStyle(
                        color: Color(0xFF090B0E),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Living my best life.',
                      style: TextStyle(
                        color: Color(0xFF909DAD),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          _openBottomSheet();
                        }, icon: Icon(Icons.more_horiz)),
                  );
                },
              ),
              Text(
                'MEMBERS -26',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF909DAD),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.20,
                ),
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80"),
                    ),
                    title: Text(
                      'Ravi Shastri',
                      style: TextStyle(
                        color: Color(0xFF090B0E),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Living my best life.',
                      style: TextStyle(
                        color: Color(0xFF909DAD),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: () {}, icon: Icon(Icons.more_horiz)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

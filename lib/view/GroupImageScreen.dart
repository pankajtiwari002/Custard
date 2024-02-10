// import 'dart:developer';

// import 'package:custard_flutter/view/AllPhotosScreen.dart';
// import 'package:custard_flutter/view/InvitePeopleScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../components/UserPhotosContainer.dart';

// class GroupImageScreen extends StatelessWidget {

//   final snapshot;
//   int index;
//   GroupImageScreen({required this.snapshot,required this.index});

//   List<String> images = [
//     "https://images.unsplash.com/photo-1524601500432-1e1a4c71d692?auto=format&fit=crop&q=80&w=1000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGdyb3VwfGVufDB8fDB8fHww",
//     "https://media.istockphoto.com/id/1384618716/photo/group-of-happy-friends-taking-selfie-pic-outside-happy-different-young-people-having-fun.webp?b=1&s=170667a&w=0&k=20&c=wWtYoTCWJUZqJK-ehBglTVxA4PtuDUZf1FVWLP2ddcA=",
//     "https://www.shutterstock.com/shutterstock/photos/2116991546/display_1500/stock-photo-multi-ethnic-guys-and-girls-taking-selfie-outdoors-with-backlight-happy-life-style-friendship-2116991546.jpg",
//     "https://assets.volvo.com/is/image/VolvoInformationTechnologyAB/join-us-banner?qlt=82&wid=1024&ts=1624538498965&dpr=off&fit=constrain"
//   ];

//   void showCustomBottomSheet() {
//     Get.bottomSheet(
//       ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//         child: Container(
//           color: Colors.white,
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Upload Media",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.cancel),
//                       onPressed: () {
//                         Get.back();
//                       },
//                     ),
//                   ],
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.camera_alt),
//                   title: Text("Camera"),
//                   onTap: () {
//                     // Add your camera logic here
//                     Get.back();
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.photo),
//                   title: Text("Gallery"),
//                   onTap: () {
//                     // Add your gallery logic here
//                     Get.back();
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.link),
//                   title: Text("Link"),
//                   onTap: () {
//                     Get.back();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void onPress(){
//     Get.to(() => AllPhotos(images: images));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           'Social Dance Tribe',
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(
//               Icons.arrow_back_ios,
//               color: Colors.white,
//             )),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 showCustomBottomSheet();
//               },
//               icon: Icon(
//                 Icons.grid_on,
//                 color: Colors.white,
//               )),
//           IconButton(
//               onPressed: () {
//                 log(snapshot.data.docs[index].id);
//                 Get.to(() => InvitePeopleScreen(eventId: snapshot.data.docs[index].id,));
//               },
//               icon: Icon(
//                 Icons.group,
//                 color: Colors.white,
//               ))
//         ],
//       ),
//       body: Padding(
//           padding: EdgeInsets.all(10),
//           child: ListView.builder(
//               itemCount: 3,
//               itemBuilder: (context, index) {
//                 return UserPhotosContainer(
//                     images: images,
//                     title: "title",
//                     onPress: onPress,
//                     userImage:
//                         "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3VzdG9tZXIlMjBwcm9maWxlfGVufDB8fDB8fHww&w=1000&q=80");
//               })),
//     );
//   }
// }

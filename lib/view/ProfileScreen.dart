import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  String imageUrl;
  ProfileScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            height: MediaQuery.of(context).size.height,
            child: Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Virat Kohli'),
                      SizedBox(
                        width: 120,
                        child: TextButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                                BorderSide(color: Color(0xFF7B61FF))),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Chat now',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF7B61FF),
                              fontSize: 16,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Mutual Chapters',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                    ],
                  ),
                  Text(
                    'About',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature's beauty.",
                    style: TextStyle(
                      color: Color(0xFF546881),
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Skills',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Wrap(
                    spacing: 5,
                    children: [
                      Chip(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        label: Text('Photography'),
                      ),
                      Chip(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        label: Text('Designing'),
                      ),
                      Chip(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        label: Text('Web Dev'),
                      ),
                    ],
                  ),
                  Text(
                    'Socials',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF090B0E),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        // color: Colors.red,
                        child: Image.network("https://img.freepik.com/premium-vector/purple-gradiend-social-media-logo_197792-1883.jpg",fit: BoxFit.cover,),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        // color: Colors.red,
                        child: Image.network("https://logowik.com/content/uploads/images/twitter-x5265.logowik.com.webp",fit: BoxFit.cover,),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        // color: Colors.red,
                        child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXxbIq3iItCF95s2226mSDGDLsgOn0xWaTZg&usqp=CAU",fit: BoxFit.cover,),
                      ),

                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

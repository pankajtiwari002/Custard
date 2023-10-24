import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:custard_flutter/components/RadioButtonTile.dart';
import 'package:custard_flutter/components/SlideShowContainer.dart';
import 'package:custard_flutter/controllers/ChapterControllers.dart';
import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:custard_flutter/view/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:get/get.dart';

import '../components/CommunityCard.dart';
import '../components/DashedBox.dart';

class ChapterOboardingScreen extends StatelessWidget {
  var controller = Get.put(ChapterControllers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12),
        child: SlideShowContainer(
          widgets: [
            _locationScreen(),
            _bioScreen(),
            _communityPrice(),
            _processingFees(),
            _themeCard()
          ],
          onFinish: () {
            Get.to(HomeScreen());
          },
        ),
      ),
    );
  }

  _locationScreen() {
    return Column(
      children: [
        Image(image: AssetImage('assets/location.png')),
        SizedBox(
          width: 20,
          height: 16,
        ),
        Text(
          'Enter the location of the chapter',
          style: TextStyle(
            color: Color(0xFF141414),
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          width: 20,
          height: 8,
        ),
        CustardTextField(
            labelText: "Search Location",
            controller: controller.locationController
        )
      ],
    );
  }

  _bioScreen() {
    return Column(
      children: [
        CommunityCard(
          widgets: [
            Text(
                '“Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature\'s beauty”',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF061237),
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500
                )
            ),
            DashedBox(
              widget: [
                Icon(Icons.lock,size: 16),
                SizedBox(width: 12, height: 12),
                Text(
                  'Anyone can join for free',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1D2848),
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(
          width: 12,
          height: 12,
        ),
        Text(
          'Add a Bio',
          style: TextStyle(
            color: Color(0xFF141414),
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700
          ),
        ),
        CustardTextField(
            labelText: "Bio",
            controller: controller.bioController
        ),
        Row(
          children: [
            Switch(
                value: controller.memberApproval,
                onChanged: (value) {
                  controller.memberApproval = value;
                }
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Do you want a member approval',
                  style: TextStyle(
                    color: Color(0xFF344053),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  'By approving this, members can directly enter into the community',
                  style: TextStyle(
                    color: Color(0xFF667084),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  _communityPrice() {
    return Column(
      children: [
        CommunityCard(
          widgets: [
            Text(
                '“Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature\'s beauty”',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF061237),
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500
                )
            ),
            DashedBox(
              widget: [
                Icon(Icons.lock,size: 16),
                SizedBox(width: 12, height: 12),
                Text(
                  'Anyone can join for free',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1D2848),
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(
          width: 12,
          height: 12,
        ),
        Text(
          'How a member can access your communtiy?',
          style: TextStyle(
            color: Color(0xFF141414),
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700
          ),
        ),
        Text(
          'You can change this anytime',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF090B0E),
            fontSize: 12,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        FlutterToggleTab(
          width: 90,
          borderRadius: 15,
          selectedIndex: controller.tabSelected,
          selectedTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600),
          unSelectedTextStyle: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w400),
          labels: [
            "Monthly Membership",
            "Start with Free"
          ],
          selectedLabelIndex: (index) {
            controller.tabSelected = index;
          },
        )
      ],
    );
  }

  _processingFees() {
    var _value = 1.obs;
    return Column(
      children: [
        Text(
          'You Decide: Who Covers Processing Fees?',
          style: TextStyle(
            color: Color(0xFF141414),
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
        Text(
          'You can change this anytime',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF090B0E),
            fontSize: 12,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        Obx(() => RadioButtonTile(
            value: 1,
            groupValue: _value.value,
            onChanged: (value) => {_value.value = value! as int},
            body: Text(
              'You’ll be charged 8% processing fee for each transaction',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 12,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500
              ),
            ),
            title: Text(
              'Me',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600
              ),
            )
          )
        ),
        Obx(
          () => RadioButtonTile(
              value: 2,
              groupValue: _value.value,
              onChanged: (value) => {_value.value = value! as int},
              body: Text(
                'You’ll be charged 8% processing fee for each transaction',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF090B0E),
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500
                ),
              ),
              title: Text(
                'My Members',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF090B0E),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600
                ),
            )
          ),
        )
      ],
    );
  }

  _themeCard() {
    var themes = [
      ThemeCard(image: "assets/temp.png", title: "title"),
      ThemeCard(image: "assets/temp.png", title: "title"),
      ThemeCard(image: "assets/temp.png", title: "title"),
      ThemeCard(image: "assets/temp.png", title: "title"),
      ThemeCard(image: "assets/temp.png", title: "title"),
      ThemeCard(image: "assets/temp.png", title: "title")
    ].obs;

    return Column(
      children: [
        CommunityCard(
          widgets: [
            Text(
                '“Jumping foxes dance swiftly under the moonlit sky, creating a mesmerizing spectacle of nature\'s beauty”',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF061237),
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500
                )
            ),
            DashedBox(
              widget: [
                Icon(Icons.lock,size: 16),
                SizedBox(width: 12, height: 12),
                Text(
                  'Anyone can join for free',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1D2848),
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            ElevatedButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      'custard.io/design-z',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 0.14,
                        letterSpacing: 0.30,
                      ),
                    ),
                    Icon(
                        Icons.link,
                      color: Colors.white,
                    )
                  ],
                ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustardColors.appTheme
              ),
            )
          ],
        ),
        SizedBox(
          width: 12,
          height: 12,
        ),
        Text(
          'Theme',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color(0xFF090B0E),
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700
           )
        ),
        Container(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: themes.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) =>
                  _themeCardUI(themes[index])
          ),
        ),
      ],
    );
  }

  _themeCardUI(ThemeCard data) {
    return Container(
      width: 100,
      height: 200,
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(image: AssetImage(data.image)),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF090B0E),
              fontSize: 12,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600
            ),
          )
        ],
      ),
    );
  }
}

class ThemeCard{
  String image;
  String title;

  ThemeCard({required this.image,required this.title});
}
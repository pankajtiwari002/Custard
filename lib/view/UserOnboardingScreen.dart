import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:custard_flutter/controllers/UserOnboardingController.dart';
import 'package:custard_flutter/utils/CustardColors.dart';
import 'package:custard_flutter/view/CommunityOnboardingScreen.dart';
import 'package:custard_flutter/view/CongratsScreen.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../components/SlideShowContainer.dart';
import '../components/TitleBodyContainer.dart';

class UserOnboardingScreen extends StatelessWidget {
  final controller = Get.put(UserOnboardingController());

  UserOnboardingScreen({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SlideShowContainer(
            widgets: [
              _nameScreen(),
              _genderScreen(),
              _photoScreen(),
              _bioScreen()
            ],
            onFinish: () {
              Get.to(
                  CongratsScreen(
                    backgroundColor: Colors.red,
                    image: const AssetImage('assets/avatar.png'),
                    next: CommunityOnboardingScreen(),
                    message: 'Congratulation! \n Your profile is created',
                    label: 'Join a Community',
                  )
              );
            },
          ),
        )
    );
  }

  _nameScreen() {
    return Column(
      children: [
        TitleBodyContainer(
            "Hi! Priya Bhatt",
            "It’s your brand new profile! Wanna change it up? You can do that from your account settings."
        ),
        const SizedBox(height: 24),
        CustardTextField(
            labelText: "Name",
            controller: controller.nameController
        )
      ],
    );
  }

  _genderScreen() {
     return Column(
       children: [
         TitleBodyContainer(
             "Hi! Prteek",
             "It’s your brand new profile! Wanna change it up? You can do that from your account settings."
         ),
         const SizedBox(height: 24),
         CustomRadioButton(
             buttonLables: const [
               "Male",
               "Female",
               "Others"
             ],
             buttonValues: const [
               "MALE",
               "FEMALE",
               "OTHERS"
             ],
             radioButtonValue: (value) {
               Get.snackbar("title", value);
             },
           height: 50,
           horizontal: true,
             unSelectedColor: Colors.white,
             selectedColor: CustardColors.appTheme,
              enableShape: true,
         )
       ],
     );
  }

  _photoScreen() {
   return Column(
     children: [
       TitleBodyContainer(
           "Hi! Priya Bhatt",
           "It’s your brand new profile! Wanna change it up? You can do that from your account settings."
       ),
       const CircleAvatar(
         radius: 75,
         backgroundImage: AssetImage('assets/avatar.png'),
       ),
       Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           TextButton(
               onPressed: () {},
               child: const Row(
                 children: [
                   Icon(Icons.upload),
                   Text("Upload picture")
                 ],
               )
           )
         ],
       )
     ],
   );
  }

  _bioScreen() {
   return Column(
     children: [
       TitleBodyContainer(
           "Hi! Priya Bhatt",
           "It’s your brand new profile! Wanna change it up? You can do that from your account settings."
       ),
       CustardTextField(
           labelText: "Bio",
           controller: controller.bioController
       )
     ],
   );
  }
}
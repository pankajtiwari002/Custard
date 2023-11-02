import 'dart:typed_data';

import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:custard_flutter/components/UserPhotosContainer.dart';
import 'package:custard_flutter/controllers/AddPhotoController.dart';
import 'package:custard_flutter/view/AddParticipants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoScreen extends StatelessWidget {
  var controller = Get.put(AddPhotoController());
  RxList<Uint8List> images = RxList();
  AddPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF242424),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {}),
        title: Text(
          'Social Dance Tribe',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Group name',
                  style: TextStyle(
                      color: Color(0xFF141414),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600)),
              Material(
                child: CustardTextField(
                    labelText: "name", controller: controller.grpName),
              ),
              // Expanded(
              //   child: GridView.count(
              //     crossAxisCount: 3,
              //     children: List.generate(100, (index) {
              //       return Center(
              //         child: _photoTile(),
              //       );
              //     }),
              //   )
              // ),
              SizedBox(
                height: 10,
              ),
              // UserPhotosContainer(
              //     images: [
              //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&usqp=CAU",
              //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&usqp=CAU",
              //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&usqp=CAU",
              //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&usqp=CAU"
              //     ],
              //     title: "title",
              //     onPress: () {},
              //     userImage:
              //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLMI5YxZE03Vnj-s-sth2_JxlPd30Zy7yEGg&usqp=CAU"),
              PhotosContainer(),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(
                'Participants',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF090B0E),
                  fontSize: 18,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.participants.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("assets/avatar.png"),
                          radius: 24,
                        ),
                        title: Text(controller.participants[index]['name']),
                      );
                    }),
              ),
              // Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: CustardButton(
            onPressed: () async {
              Get.to(AddParticipationsScreens());
            },
            buttonType: ButtonType.NEGATIVE,
            label: "Add Participants"),
      ),
    );
  }

  _photoTile() {
    return Image(image: NetworkImage("https://via.placeholder.com/100x100"));
  }
}

class PhotosContainer extends StatelessWidget {
  AddPhotoController controller = Get.find();
  Future<void> _pickMultiImages() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();
    List<Uint8List> pImages = [];
    if (pickedImages != null) {
      print("Not NULL");
      for (XFile file in pickedImages) {
        Uint8List bytes = await file.readAsBytes();
        pImages.add(bytes);
      }
      controller.images.addAll(pImages);
      print("images length: " + controller.images.length.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.builder(
        shrinkWrap: true,
        itemCount: controller.images.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 0,
        ),
        itemBuilder: (context, index) {
          if (index < controller.images.length) {
            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: MemoryImage(controller.images[index]),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10)),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: IconButton(
                      onPressed: () {
                        controller.images.removeAt(index);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                      )),
                )
              ],
            );
          } else {
            return InkWell(
              onTap: () {
                _pickMultiImages();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 240, 239, 239)),
                alignment: Alignment.center,
                child: Text(
                  "+\nAdd more\nPhotos",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }));
  }
}

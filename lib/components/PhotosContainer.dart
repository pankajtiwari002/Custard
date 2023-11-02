import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/GroupCreationController.dart';

class PhotosContainer extends StatelessWidget {
  GroupCreationController controller = Get.find();
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
      primary: false,
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

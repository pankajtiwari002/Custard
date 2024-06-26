import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage(ImageSource source) async{
  ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);

  // if(_file!=null){
  //   return _file.readAsBytes();
  // }
  return _file;
  // print("No image selected");
}

Future<String?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'], // Add the allowed document types
    );

    // File? selectedDocument;
    // if (result != null) {
    //   selectedDocument = File(result.files.single.path!);
    // }
    if(result != null){
      return result.files.single.path;
    }
}

pickVideo(ImageSource source) async{
  ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickVideo(source: source);
  if(_file!=null){
    return _file;
  }
  print("No image selected");
}
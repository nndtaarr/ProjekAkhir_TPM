import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projek_tpm/helper/common_submit_button.dart';
import 'package:projek_tpm/helper/shared_preference.dart';
import 'image_picker_helper.dart';

class ImagePickerSection extends StatefulWidget {
  const ImagePickerSection({Key? key}) : super(key: key);

  @override
  _ImagePickerSectionState createState() => _ImagePickerSectionState();
}

class _ImagePickerSectionState extends State<ImagePickerSection> {
  String imagePath = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: _imageSection(),
        ),
        _buttonSectionGallery(),
        _buttonSectionCamera(),
      ],
    );
  }

  Widget _buttonSectionCamera() {
    return CommonSubmitButton(
        labelButton: "Import Dari Camera",
        submitCallback: (value) {
          imagePath = '';
          ImagePickerHelper()
              .getImageFromCamera((value) => _processImage(value));
        });
  }

  Widget _buttonSectionGallery() {
    return CommonSubmitButton(
        labelButton: "Import Dari Gallery",
        submitCallback: (value) {
          imagePath = '';
          ImagePickerHelper()
              .getImageFromGallery((value) => _processImage(value));
        });
  }

  Widget _imageSection() {
    if (imagePath.isEmpty) {
      return const CircleAvatar(
        radius: 100.0,
        child: Center(child: Text("NO PHOTO")),
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: 100,
      child: CircleAvatar(
        radius: 95,
        backgroundImage: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ).image,
      ),
    );
  }

  void _processImage(String? value) async {
    String saved = await SharedPreference.getImage();
    if (value != null) {
      setState(() {
        if (imagePath == "") {
          imagePath = value;
          SharedPreference().setImage(imagePath);
        }
      });
    } else {
      setState(() {
        imagePath = saved;
        SharedPreference().setImage(imagePath);
      });
    }
    ;
  }
}

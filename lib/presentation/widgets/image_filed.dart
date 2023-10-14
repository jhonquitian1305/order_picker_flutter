import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_picker/presentation/widgets/button.dart';
import 'package:tabler_icons/tabler_icons.dart';

class ImageField extends StatefulWidget {
  final void Function(File?) onChange;
  const ImageField({
    super.key,
    required this.onChange,
  });

  @override
  State<StatefulWidget> createState() {
    return _ImageFieldState();
  }
}

class _ImageFieldState extends State<ImageField> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(children: [
          Container(
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey.shade700,
              ),
              borderRadius: BorderRadius.circular(21),
            ),
            child: imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ))
                : Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 120),
                    child: const Column(
                      children: [
                        Icon(
                          TablerIcons.photo_cancel,
                          color: Color.fromRGBO(85, 85, 85, 0.5),
                          size: 80,
                        ),
                        Text(
                          "Select an Image",
                          textScaleFactor: 2,
                          style: TextStyle(
                            color: Color.fromRGBO(85, 85, 85, 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Container(height: 35, color: Colors.transparent),
        ]),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: pickButtons(),
        ),
      ],
    );
  }

  Row pickButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Button(
          onPressed: () {
            _getFromGallery();
          },
          child: const Icon(
            TablerIcons.photo_plus,
            color: Colors.white,
            size: 25,
          ),
        ),
        const SizedBox(width: 5),
        Button(
          onPressed: () {
            _getFromCamera();
          },
          child: const Icon(
            TablerIcons.camera_plus,
            color: Colors.white,
            size: 25,
          ),
        ),
      ],
    );
  }

  _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        widget.onChange(imageFile);
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        widget.onChange(imageFile);
      });
    }
  }
}

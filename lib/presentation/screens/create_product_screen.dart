import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabler_icons/tabler_icons.dart';

class NewProductDemo extends StatefulWidget {
  const NewProductDemo({super.key});

  @override
  _NewProductDemoState createState() => _NewProductDemoState();
}

class _NewProductDemoState extends State<NewProductDemo> {
  File? imageFile;
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("New Product"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(children: [
            imagePicker(),
            const SizedBox(height: 10),
            const InputText(
              hintText: 'Enter valid username',
              labelText: 'Username',
            ),
            const SizedBox(height: 10),
            const InputText(
              hintText: 'Enter password',
              labelText: 'Password',
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: Theme.of(context).textButtonTheme.style,
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Create Product',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            Container(
              child: imageUrl != null
                  ? Column(
                      children: [Text(imageUrl!), Image.network(imageUrl!)])
                  : null,
            )
          ]),
        ),
      ),
    );
  }

  Stack imagePicker() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(children: [
          Container(
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: Colors.grey.shade700,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 120),
                      child: const Text("Select an Image", textScaleFactor: 2),
                    ),
                  ),
          ),
          Container(height: 35, color: Colors.transparent),
        ]),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: pickerControlButtons(),
        ),
      ],
    );
  }

  Widget pickerControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: IconButton(
            style: Theme.of(context).textButtonTheme.style,
            padding: const EdgeInsets.all(15),
            onPressed: () {
              _getFromGallery();
            },
            icon: const Icon(
              TablerIcons.photo_plus,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: IconButton(
            style: Theme.of(context).textButtonTheme.style,
            padding: const EdgeInsets.all(15),
            onPressed: () {
              _getFromCamera();
            },
            icon: const Icon(
              TablerIcons.camera_plus,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 5),
        if (imageFile != null)
          Expanded(
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
              ),
              padding: const EdgeInsets.all(15),
              onPressed: () {
                setState(() {
                  imageFile = null;
                });
              },
              icon: const Icon(
                TablerIcons.photo_x,
                color: Colors.white,
                size: 30,
              ),
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
      });
    }
  }
}

class InputText extends StatelessWidget {
  final String labelText;
  final String hintText;

  const InputText({super.key, required this.hintText, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          labelText: labelText,
          hintText: hintText),
    );
  }
}

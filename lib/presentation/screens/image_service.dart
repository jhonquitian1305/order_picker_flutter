import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final imagesRef = FirebaseStorage.instance.ref().child("product_images");

Future<String> uploadImage(File image) async {
  String imageName = image.path.split('/').last;
  Reference imageRef = imagesRef.child(imageName);
  try {
    await imageRef.putFile(image);
  } on Exception {
    print('oh no! algo falló');
  }
  print("parece que funcó");
  return await imageRef.getDownloadURL();
}



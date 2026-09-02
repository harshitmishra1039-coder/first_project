import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  Future<String> uploadImage(File image) async {
    String fileName =
        DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref =
        _storage.ref().child('crop_images/$fileName');

    await ref.putFile(image);

    return await ref.getDownloadURL();
  }
}
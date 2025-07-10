import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageClass {
  // Firebase Storage instance (singleton)
  static final _storage = FirebaseStorage.instance;

  // 🔹 Upload an image to Firebase Storage
  // Params:
  // - imageFile: the local image file to upload
  // - folderPath: the path in the Firebase Storage bucket where the image will be stored
  // - fileName: the name with which the image will be saved
  // Returns: the download URL of the uploaded image
  static Future<String> uploadImage({
    required File imageFile,
    required String folderPath,
    required String fileName,
  }) async {
    try {
      // Create a reference to the desired file path
      final ref = _storage.ref("$folderPath/$fileName");

      // Upload the file to Firebase Storage
      final uploadTask = await ref.putFile(imageFile);

      // Get and return the public download URL
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      // Log error in debug mode and rethrow it
      if (kDebugMode) {
        debugPrint("Error occurred while uploading the image: $e");
      }
      return Future.error("Error occurred while uploading the image: $e");
    }
  }

  // 🔹 Delete an image from Firebase Storage
  // Params:
  // - filePath: the full path of the file in the Firebase Storage bucket
  static deleteImage({required String filePath}) async {
    try {
      // Create a reference to the file to be deleted
      final ref = _storage.ref(filePath);

      // Delete the file
      await ref.delete();
    } catch (e) {
      // Log error in debug mode and rethrow it
      if (kDebugMode) {
        debugPrint("Error occurred while deleting the image: $e");
      }
      return Future.error("Error occurred while deleting the image: $e");
    }
  }
}

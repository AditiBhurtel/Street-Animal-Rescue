import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class
FirebaseStorageServices {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Future<String?> uploadImageAndGetUrl(dynamic image, {required String? collection, required String? imageName}) async {
    if (image != null) {
      final ref = firebaseStorage.ref('${collection ?? 'temp'}/${randomAlphaNumeric(15)}_$imageName');
      UploadTask uploadTask;
      uploadTask = ref.putFile(image);
      return await uploadTask.then((tSnap) {
        return tSnap.ref.getDownloadURL().then((url) {
          return url;
        });
      });
    }
    return null;
  }

  Future<String?> uploadUint8ListImageAndGetUrl(Uint8List image, {required String? collection, required String? imageName}) async {
    final ref = firebaseStorage.ref('${collection ?? 'temp'}/${randomAlphaNumeric(15)}_$imageName');
    UploadTask uploadTask;
    uploadTask = ref.putData(image);
    final url = await uploadTask.then((tSnap) {
      return tSnap.ref.getDownloadURL().then((url) {
        return url;
      });
    });
    return url;
  }

  Future<void> deleteImageFromStorage(String imageUrl) async {
    final ref = firebaseStorage.refFromURL(imageUrl);
    await ref.delete();
  }
}

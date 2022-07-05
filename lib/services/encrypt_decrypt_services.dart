import 'package:encrypt/encrypt.dart';

class EncryptDecryptServices {
  final key = Key.fromUtf8('TheQuickBrownFoxJumpsOverTheLazy');
  final iv = IV.fromLength(16);

  Encrypter getEncrypter() {
    return Encrypter(AES(key));
  }

  String encryptData(String data) {
    return getEncrypter().encrypt(data, iv: iv).base64;
  }

  String decryptData(String data) {
    return getEncrypter().decrypt64(data, iv: iv);
  }
}

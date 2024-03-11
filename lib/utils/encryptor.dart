import 'package:encrypt/encrypt.dart';

final key = Key.fromUtf8('1kf8hj4Hr(3jg&tdW375uSje385Wuqjc'); //32 chars
final iv = IV.fromUtf8('kdkjdfjlk2390384'); //16 chars

//encrypt
String encryptor(String text) {
  final e = Encrypter(AES(key, mode: AESMode.cbc));
  final encryptedData = e.encrypt(text, iv: iv);
  return encryptedData.base64;
}

//dycrypt
String decryptor(String text) {
  final e = Encrypter(AES(key, mode: AESMode.cbc));
  final decryptedData = e.decrypt(Encrypted.fromBase64(text), iv: iv);
  return decryptedData;
}

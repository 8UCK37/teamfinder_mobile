import 'dart:convert';
import 'package:encrypt_decrypt_plus/cipher/cipher.dart';


class CryptoBro {

  static Cipher cipher = Cipher(secretKey: "datadirr");
  
  

  static String encrypt(String data) {
    String encryptTxt = cipher.xorEncode(data);
    return encryptTxt;
  }

  static String decrypt(String encryptedData) {
    String decryptTxt = cipher.xorDecode(encryptedData);
    return decryptTxt;
  }

  static String encryptMap(Map<String, String> dataMap) {
    final jsonString = jsonEncode(dataMap);
    return encrypt(jsonString);
  }

  static Map<String, String> decryptMap(String encryptedData) {
    final decryptedString = decrypt(encryptedData);
    return jsonDecode(decryptedString);
  }

}

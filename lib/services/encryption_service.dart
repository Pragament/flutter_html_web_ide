import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static Encrypted encryptPassword(String password, String phoneLast6) {
    final key = Key.fromUtf8(phoneLast6.padRight(32, '0'));

    final encrypter = Encrypter(
      AES(
        key,
        mode: AESMode.ecb, //  deterministic, no IV
        padding: 'PKCS7',
      ),
    );

    return encrypter.encrypt(password);
  }
}

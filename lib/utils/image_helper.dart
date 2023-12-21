import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageHelper {

  static Future<File> compressImage(String imagePath, int quality,String name) async {
    File imageFile = File(imagePath);
    img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;

    // Convert the image to bytes with the specified quality
    List<int> compressedBytes = img.encodeJpg(image, quality: quality);

    Directory tempDir = await getTemporaryDirectory();
    String compressedImagePath = '${tempDir.path}/$name.jpg';

    // Save the compressed image to a new file
    File compressedImageFile = File(compressedImagePath);
    await compressedImageFile.writeAsBytes(compressedBytes);

    return compressedImageFile;
  }

  static Future<String> saveEditedImage(Uint8List editedImage,String name) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Generate a unique filename based on the current timestamp.
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String newImagePath = '$appDocPath/$name"_"$timestamp.png';

    // Write the edited image data to the file.
    File newImageFile = File(newImagePath);
    await newImageFile.writeAsBytes(editedImage);

    return newImagePath;
  }
}

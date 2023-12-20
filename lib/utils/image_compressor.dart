import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageCompressor {
  static Future<File> compressImage(String imagePath, int quality) async {
    File imageFile = File(imagePath);
    img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;

    // Convert the image to bytes with the specified quality
    List<int> compressedBytes = img.encodeJpg(image, quality: quality);

    Directory tempDir = await getTemporaryDirectory();
    String compressedImagePath = '${tempDir.path}/compressed_image.jpg';

    // Save the compressed image to a new file
    File compressedImageFile = File(compressedImagePath);
    await compressedImageFile.writeAsBytes(compressedBytes);

    return compressedImageFile;
  }
}

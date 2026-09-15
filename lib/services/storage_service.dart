import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProductImage({
    required XFile image,
    required String productId,
    required int imageIndex,
  }) async {
    final Uint8List imageBytes = await image.readAsBytes();

    final String fileExtension = _getFileExtension(image.name);

    final String filePath =
        'products/$productId/image_${imageIndex + 1}.$fileExtension';

    final Reference storageReference = _storage.ref().child(filePath);

    final SettableMetadata metadata = SettableMetadata(
      contentType: _getContentType(fileExtension),
      customMetadata: {'productId': productId, 'originalFileName': image.name},
    );

    await storageReference.putData(imageBytes, metadata);

    return storageReference.getDownloadURL();
  }

  Future<List<String>> uploadProductImages({
    required List<XFile> images,
    required String productId,
  }) async {
    final List<String> imageUrls = [];

    for (int index = 0; index < images.length; index++) {
      final String imageUrl = await uploadProductImage(
        image: images[index],
        productId: productId,
        imageIndex: index,
      );

      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  Future<void> deleteProductImage(String imageUrl) async {
    try {
      final Reference imageReference = _storage.refFromURL(imageUrl);

      await imageReference.delete();
    } catch (_) {
      // Ignore deletion errors if the file does not exist.
    }
  }

  String _getFileExtension(String fileName) {
    final String extension = fileName.split('.').last.toLowerCase();

    if (extension == 'jpeg') {
      return 'jpg';
    }

    return extension;
  }

  String _getContentType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}

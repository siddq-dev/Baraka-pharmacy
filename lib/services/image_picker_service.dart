import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  static const int maxImageSizeInBytes = 5 * 1024 * 1024;

  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  /// Picks one image from the device gallery.
  ///
  /// Returns null if the user cancels the picker.
  /// Throws an exception if the image is larger than 5 MB
  /// or has an unsupported file format.
  Future<XFile?> pickSingleImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return null;
    }

    await _validateImage(image);

    return image;
  }

  /// Picks multiple images from the device gallery.
  ///
  /// Returns an empty list if the user cancels the picker.
  /// Each image must be 5 MB or smaller.
  Future<List<XFile>> pickMultipleImages({int maximumImages = 5}) async {
    final List<XFile> selectedImages = await _imagePicker.pickMultiImage();

    if (selectedImages.isEmpty) {
      return [];
    }

    final List<XFile> validImages = [];

    for (final image in selectedImages) {
      if (validImages.length >= maximumImages) {
        break;
      }

      await _validateImage(image);
      validImages.add(image);
    }

    return validImages;
  }

  Future<void> _validateImage(XFile image) async {
    final int imageSize = await image.length();

    if (imageSize > maxImageSizeInBytes) {
      throw Exception(
        'Image "${image.name}" is larger than 5 MB. '
        'Please select a smaller image.',
      );
    }

    final String fileName = image.name.toLowerCase();
    final String extension = fileName.split('.').last;

    if (!allowedExtensions.contains(extension)) {
      throw Exception(
        'Unsupported image format. '
        'Please select JPG, JPEG, PNG, or WEBP image.',
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../ai_barcode_scanner.dart';

/// A button that allows the user to pick an image from the gallery
/// and analyze it for barcodes & QR codes.
class GalleryButton extends StatelessWidget {
  final void Function(String?)? onImagePick;
  final void Function(BarcodeCapture)? onDetect;
  final bool Function(BarcodeCapture)? validator;
  final MobileScannerController controller;
  final ValueNotifier<bool?> isSuccess;
  final String child;

  const GalleryButton({
    super.key,
    this.onImagePick,
    this.onDetect,
    this.validator,
    required this.controller,
    required this.isSuccess,
    this.child = 'Gallery',
  });

  const GalleryButton.icon({
    super.key,
    this.onImagePick,
    this.onDetect,
    this.validator,
    required this.controller,
    required this.isSuccess,
    this.child = 'Icon',
  });

  @override
  Widget build(BuildContext context) {
    Future<void> pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      onImagePick?.call(image?.path);
      if (image != null) {
        final barcodes = await controller.analyzeImage(image.path);
        if (barcodes != null) {
          HapticFeedback.mediumImpact();
          onDetect?.call(barcodes);
          if (validator != null) {
            final isValid = validator!(barcodes);
            if (!isValid) {
              HapticFeedback.heavyImpact();
            }
            HapticFeedback.mediumImpact();
            isSuccess.value = isValid;
          }
        }
      }
    }

    switch (child) {
      case 'Icon':
        return IconButton(
          icon: const Icon(Icons.image),
          onPressed: pickImage,
        );
      default:
        return FilledButton.icon(
          onPressed: pickImage,
          label: const Text("Upload from Gallery"),
          icon: const Icon(Icons.image_rounded),
        );
    }
  }
}

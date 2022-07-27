# ai_barcode_scanner

[![pub package](https://img.shields.io/pub/v/ai_barcode_scanner.svg)](https://pub.dev/packages/ai_barcode_scanner)

A universal barcode and QR code scanner for Flutter based on MLKit. Uses CameraX on Android, AVFoundation on iOS and Apple Vision & AVFoundation on macOS.

<table>
  <tr>
    <td>Video </td>
     <td>Decoded Address</td>
  </tr>
  <tr>
<td><img src="https://raw.githubusercontent.com/rvndsngwn/map_location_picker/master/assets/GIF_4300.gif" width=270 height=480 alt=""></td>
<td><img src="https://raw.githubusercontent.com/rvndsngwn/map_location_picker/master/assets/IMG_2480.PNG" width=270 height=480 alt=""></td>
</tr>
</table>

### Android
SDK 21 and newer. Reason: CameraX requires at least SDK 21.
Also, make sure you upgrade kotlin to the latest version in your project.

This packages uses the **bundled version** of MLKit Barcode-scanning for Android. This version is more accurate and immediately available to devices. However, this version will increas the size of the app with approximately 3 to 10 MB. The alternative for this is to use the **unbundled version** of MLKit Barcode-scanning for Android. This version is older than the bundled version however this only increases the size by around 600KB.

To use this version you must alter the ai_barcode_scanner gradle file to replace `com.google.mlkit:barcode-scanning:17.0.2` with `com.google.android.gms:play-services-mlkit-barcode-scanning:18.0.0`. Keep in mind that if you alter the gradle files directly in your project it can be overriden when you update your pubspec.yaml. I am still searching for a way to properly replace the module in gradle but have yet to find one.

[You can read more about the difference between the two versions here.](https://developers.google.com/ml-kit/vision/barcode-scanning/android)

### iOS
iOS 11 and newer. Reason: MLKit for iOS requires at least iOS 10 and a [64bit device](https://developers.google.com/ml-kit/migration/ios).

**Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:**

NSCameraUsageDescription - describe why your app needs access to the camera. This is called Privacy - Camera Usage Description in the visual editor.

**If you want to use the local gallery feature from [image_picker](https://pub.dev/packages/image_picker)**

NSPhotoLibraryUsageDescription - describe why your app needs permission for the photo library. This is called Privacy - Photo Library Usage Description in the visual editor.

### macOS
macOS 10.13 or newer. Reason: Apple Vision library.

### Web
Add this to `web/index.html`:

```html
<script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js"></script>
```

Web only supports QR codes for now.
Do you have experience with Flutter Web development? [Help me with migrating from jsQR to qr-scanner for full barcode support!](https://github.com/juliansteenbakker/ai_barcode_scanner/issues/54)

## Usage

Import `package:ai_barcode_scanner/ai_barcode_scanner.dart`, and use the widget with or without the controller.

If you don't provide a controller, you can't control functions like the torch(flash) or switching camera.

If you don't set allowDuplicates to false, you can get multiple scans in a very short time, causing things like pop() to fire lots of times.
    
```dart
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

/// Simple example of using the barcode scanner.
BarcodeScanner(
        onScan: (String value) {
          debugPrint(value);
        },
      ),

/// Example of using the barcode scanner with a controller.
BarcodeScanner(
        controller: BarcodeScannerController(),
          onScan: (String value) {
            debugPrint(value);
          },
      ),

/// Example of using the barcode scanner with validation.
/// Validator works on the raw string, not the decoded value.
/// If you want to validate the scanner, use the [validateText] and [validateType] parameters.
BarcodeScanner(
        validateText: 'https://',
        validateType: ValidateType.startsWith,
        controller: BarcodeScannerController(),
          onScan: (String value) {
            debugPrint(value);
          },
      ),
```

### Parameters of the widget

```dart
  /// Function that gets Called when barcode is scanned successfully
  final void Function(String) onScan;

  /// Function that gets called when a Barcode is detected.
  ///
  /// [barcode] The barcode object with all information about the scanned code.
  /// [args] Information about the state of the MobileScanner widget
  final Function(Barcode barcode, MobileScannerArguments? args)? onDetect;

  /// Validate barcode text with [ValidateType]
  /// [validateText] and [validateType] must be set together.
  final String? validateText;

  /// Validate type [ValidateType]
  /// Validator working with single string value only.
  final ValidateType? validateType;

  /// Set to false if you don't want duplicate barcode to be detected
  final bool allowDuplicates;

  /// Fit to screen
  final BoxFit fit;

  /// Barcode controller (optional)
  final MobileScannerController? controller;

  /// Show overlay or not (default: true)
  final bool showOverlay;

  /// Overlay border color (default: white)
  final Color borderColor;

  /// Overlay border width (default: 10)
  final double borderWidth;

  /// Overlay color
  final Color overlayColor;

  /// Overlay border radius (default: 10)
  final double borderRadius;

  /// Overlay border length (default: 30)
  final double borderLength;

  /// Overlay cut out width (optional)
  final double? cutOutWidth;

  /// Overlay cut out height (optional)
  final double? cutOutHeight;

  /// Overlay cut out offset (default: 0)
  final double cutOutBottomOffset;

  /// Overlay cut out size (default: 300)
  final double cutOutSize;

  /// Show hint or not (default: true)
  final bool showHint;

  /// Hint text (default: 'Scan QR Code')
  final String hintText;

  /// Hint margin
  final EdgeInsetsGeometry hintMargin;

  /// Hint padding
  final EdgeInsetsGeometry hintPadding;

  /// Hint background color (optional)
  final Color? hintBackgroundColor;

  /// Hint text style
  final TextStyle hintTextStyle;

  /// Show error or not (default: true)
  final bool showError;

  /// Error color (default: red)
  final Color errorColor;

  /// Error text (default: 'Invalid BarCode')
  final String errorText;

  /// Show success or not (default: true)
  final bool showSuccess;

  /// Success color (default: green)
  final Color successColor;

  /// Success text (default: 'BarCode Found')
  final String successText;

  /// Can auto back to previous page when barcode is successfully scanned (default: true)
  final bool canPop;
```

## Thanks to
This plugin is based on the [mobile_scanner](https://pub.dev/packages/mobile_scanner) plugin by [steenbakker.dev](https://pub.dev/publishers/steenbakker.dev/packages).

I recommend you to read the [mobile_scanner](https://pub.dev/packages/mobile_scanner) plugin's documentation.

# ai_barcode_scanner

[![pub package](https://img.shields.io/pub/v/ai_barcode_scanner.svg)](https://pub.dev/packages/ai_barcode_scanner)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/juliansteenbakker?label=Sponsor%20Julian%20Steenbakker!)](https://github.com/sponsors/juliansteenbakker)

### Note:

_This plugin is based on the [mobile_scanner](https://pub.dev/packages/mobile_scanner) plugin by [steenbakker.dev](https://pub.dev/publishers/steenbakker.dev/packages)._

_Huge thanks to [Julian Steenbakker](https://github.com/sponsors/juliansteenbakker)_ 🙏

An universal barcode and QR code scanner for Flutter based on MLKit. Uses CameraX on Android, AVFoundation on iOS and Apple Vision & AVFoundation on macOS.

### What's deferent from [mobile_scanner](https://pub.dev/packages/mobile_scanner)?

_The only difference is that this plugin provides a ready to use UI widget with customizable options._

### Preview of the widget

<table>
  <tr>
    <td>Video</td>
     <td>Screenshot</td>
  </tr>
  <tr>
<td><img src="https://raw.githubusercontent.com/mohesu/barcode_scanner/master/assets/final.gif" width=250 height=480 alt=""></td>
<td><img src="https://raw.githubusercontent.com/mohesu/barcode_scanner/master/assets/final.PNG" width=250 height=480 alt=""></td>
</tr>
</table>

## Features Supported

See the example app for detailed implementation information.

| Features               | Android | iOS | macOS | Web |
| ---------------------- | ------- | --- | ----- | --- |
| analyzeImage (Gallery) | ✅      | ✅  | ❌    | ❌  |
| returnImage            | ✅      | ✅  | ❌    | ❌  |
| scanWindow             | ✅      | ✅  | ❌    | ❌  |
| barcodeOverlay         | ✅      | ✅  | ❌    | ❌  |

## Platform Support

| Android | iOS | macOS | Web | Linux | Windows |
| ------- | --- | ----- | --- | ----- | ------- |
| ✅      | ✅  | ✅    | ✅  | ❌    | ❌      |

## Platform specific setup

### Android

This packages uses the **bundled version** of MLKit Barcode-scanning for Android. This version is more accurate and immediately available to devices. However, this version will increase the size of the app with approximately 3 to 10 MB. The alternative for this is to use the **unbundled version** of MLKit Barcode-scanning for Android. This version is older than the bundled version however this only increases the size by around 600KB.
To use this version you must alter the mobile_scanner gradle file to replace `com.google.mlkit:barcode-scanning:17.0.2` with `com.google.android.gms:play-services-mlkit-barcode-scanning:18.0.0`. Keep in mind that if you alter the gradle files directly in your project it can be overriden when you update your pubspec.yaml. I am still searching for a way to properly replace the module in gradle but have yet to find one.

[You can read more about the difference between the two versions here.](https://developers.google.com/ml-kit/vision/barcode-scanning/android)

### iOS

**Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:**
NSCameraUsageDescription - describe why your app needs access to the camera. This is called Privacy - Camera Usage Description in the visual editor.

**If you want to use the local gallery feature from [image_picker](https://pub.dev/packages/image_picker)**
NSPhotoLibraryUsageDescription - describe why your app needs permission for the photo library. This is called Privacy - Photo Library Usage Description in the visual editor.

Example,

```
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photos access to get QR code from photo library</string>
```

### macOS

Ensure that you granted camera permission in XCode -> Signing & Capabilities:

<img width="696" alt="Screenshot of XCode where Camera is checked" src="https://user-images.githubusercontent.com/24459435/193464115-d76f81d0-6355-4cb2-8bee-538e413a3ad0.png">

## Usage ([ai_barcode_scanner](https://pub.dev/packages/ai_barcode_scanner))

Import `package:ai_barcode_scanner/ai_barcode_scanner.dart`, and use the widget with or without the controller.

If you don't provide a controller, you can't control functions like the torch(flash) or switching camera.

If you don't set allowDuplicates to false, you can get multiple scans in a very short time, causing things like pop() to fire lots of times.

```dart
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

/// Simple example of using the barcode scanner.
AiBarcodeScanner(
        onScan: (String value) {
          debugPrint(value);
        },
        onDetect: (BarcodeCapture barcodeCapture) {
          debugPrint(barcodeCapture);
        },
      ),

/// Example of using the barcode scanner with a controller.
AiBarcodeScanner(
        controller: MobileScannerController(),
          onScan: (String value) {
            debugPrint(value);
          },
        onDetect: (BarcodeCapture barcodeCapture) {
          debugPrint(barcodeCapture);
        },
      ),

/// Example of using the barcode scanner with validation.
/// Validator works on the raw string, not the decoded value.
/// If you want to validate the scanner, use the [validate] parameter.
AiBarcodeScanner(
        validate: (String value) {
          if(value.startsWith('http')) {
            return true;
          }
          return false;
        },
          onScan: (String value) {
            debugPrint(value);
          },
      ),
```

## Usage ([mobile_scanner](https://pub.dev/packages/mobile_scanner))

Import `package:mobile_scanner/mobile_scanner.dart`, and use the widget with or without the controller.

If you don't provide a controller, you can't control functions like the torch(flash) or switching camera.

If you don't set `detectionSpeed` to `DetectionSpeed.noDuplicates`, you can get multiple scans in a very short time, causing things like pop() to fire lots of times.

Example without controller:

```dart
import 'package:mobile_scanner/mobile_scanner.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
        // fit: BoxFit.contain,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
          }
        },
      ),
    );
  }
```

Example with controller and initial values:

```dart
import 'package:mobile_scanner/mobile_scanner.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.front,
          torchEnabled: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
          }
        },
      ),
    );
  }
```

Example with controller and torch & camera controls:

```dart
import 'package:mobile_scanner/mobile_scanner.dart';

  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mobile Scanner'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state as TorchState) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state as CameraFacing) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: MobileScanner(
          // fit: BoxFit.contain,
          controller: cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
            }
          },
        ),
    );
  }
```

Example with controller and returning images

```dart
import 'package:mobile_scanner/mobile_scanner.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
        fit: BoxFit.contain,
        controller: MobileScannerController(
          // facing: CameraFacing.back,
          // torchEnabled: false,
          returnImage: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
          }
          if (image != null) {
            showDialog(
              context: context,
              builder: (context) =>
                  Image(image: MemoryImage(image)),
            );
            Future.delayed(const Duration(seconds: 5), () {
              Navigator.pop(context);
            });
          }
        },
      ),
    );
  }
```

### BarcodeCapture

The onDetect function returns a BarcodeCapture objects which contains the following items.

| Property name | Type          | Description                       |
| ------------- | ------------- | --------------------------------- |
| barcodes      | List<Barcode> | A list with scanned barcodes.     |
| image         | Uint8List?    | If enabled, an image of the scan. |

You can use the following properties of the Barcode object.

| Property name | Type           | Description                         |
| ------------- | -------------- | ----------------------------------- |
| format        | BarcodeFormat  |                                     |
| rawBytes      | Uint8List?     | binary scan result                  |
| rawValue      | String?        | Value if barcode is in UTF-8 format |
| displayValue  | String?        |                                     |
| type          | BarcodeType    |                                     |
| calendarEvent | CalendarEvent? |                                     |
| contactInfo   | ContactInfo?   |                                     |
| driverLicense | DriverLicense? |                                     |
| email         | Email?         |                                     |
| geoPoint      | GeoPoint?      |                                     |
| phone         | Phone?         |                                     |
| sms           | SMS?           |                                     |
| url           | UrlBookmark?   |                                     |
| wifi          | WiFi?          | WiFi Access-Point details           |

### Constructor parameters for [ai_barcode_scanner](https://pub.dev/packages/ai_barcode_scanner)

```dart
  /// Function that gets Called when barcode is scanned successfully
  ///
  final void Function(String) onScan;

  /// Function that gets called when a Barcode is detected.
  ///
  /// [barcode] The barcode object with all information about the scanned code.
  /// [args] Information about the state of the MobileScanner widget
  final void Function(BarcodeCapture)? onDetect;

  /// Validate barcode text with [ValidateType]
  /// [validateText] and [validateType] must be set together.
  /// [validateText] now deprecated, use [validator] instead.
  @Deprecated('Use [validator] instead. This will be removed in next version.')
  final String? validateText;

  /// Validate type [ValidateType]
  /// Validator working with single string value only.
  /// [validateText] and [validateType] now deprecated, use [validator] instead.
  @Deprecated('Use [validator] instead. This will be removed in next version.')
  final ValidateType? validateType;

  /// Validate barcode text with a function
  final bool Function(String value)? validator;

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

  /// Hint widget (optional) (default: Text('Scan QR Code'))
  /// Hint widget will be replaced the bottom of the screen.
  /// If you want to replace the bottom screen widget, use [hintWidget]
  final Widget? hintWidget;

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

  /// The function that builds an error widget when the scanner
  /// could not be started.
  ///
  /// If this is null, defaults to a black [ColoredBox]
  /// with a centered white [Icons.error] icon.
  final Widget Function(BuildContext, MobileScannerException, Widget?)?
      errorBuilder;

  /// The function that builds a placeholder widget when the scanner
  /// is not yet displaying its camera preview.
  ///
  /// If this is null, a black [ColoredBox] is used as placeholder.
  final Widget Function(BuildContext, Widget?)? placeholderBuilder;

  /// The function that signals when the barcode scanner is started.
  final void Function(MobileScannerArguments?)? onScannerStarted;

  /// Called when this object is removed from the tree permanently.
  final void Function()? onDispose;

  /// if set barcodes will only be scanned if they fall within this [Rect]
  /// useful for having a cut-out overlay for example. these [Rect]
  /// coordinates are relative to the widget size, so by how much your
  /// rectangle overlays the actual image can depend on things like the
  /// [BoxFit]
  final Rect? scanWindow;

  /// Only set this to true if you are starting another instance of mobile_scanner
  /// right after disposing the first one, like in a PageView.
  ///
  /// Default: false
  final bool? startDelay;

```

### Contributing to [ai_barcode_scanner](https://pub.dev/packages/ai_barcode_scanner)

All contributions are welcome. Let's make this package better together.

## Thanks to all the contributors and supporters.

### Contributors

<a href="https://github.com/mohesu/barcode_scanner/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=mohesu/barcode_scanner" />
</a>

Made with [contrib.rocks](https://contrib.rocks).

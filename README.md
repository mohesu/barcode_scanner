# ai_barcode_scanner

[![pub package](https://img.shields.io/pub/v/ai_barcode_scanner.svg)](https://pub.dev/packages/ai_barcode_scanner)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/juliansteenbakker?label=Sponsor%20Julian%20Steenbakker!)](https://github.com/sponsors/juliansteenbakker)

### Screenshots

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

| Features               | Android            | iOS                | macOS | Web |
| ---------------------- | ------------------ | ------------------ | ----- | --- |
| analyzeImage (Gallery) | :heavy_check_mark: | :heavy_check_mark: | :x:   | :x: |
| returnImage            | :heavy_check_mark: | :heavy_check_mark: | :x:   | :x: |
| scanWindow             | :heavy_check_mark: | :heavy_check_mark: | :x:   | :x: |
| barcodeOverlay         | :heavy_check_mark: | :heavy_check_mark: | :x:   | :x: |

## Platform Support

| Android | iOS | macOS | Web | Linux | Windows |
| ------- | --- | ----- | --- | ----- | ------- |
| ✔       | ✔   | ✔     | ✔   | :x:   | :x:     |

## Platform specific setup

### Android

This package uses by default the **bundled version** of MLKit Barcode-scanning for Android. This version is immediately available to the device. But it will increase the size of the app by approximately 3 to 10 MB.

The alternative is to use the **unbundled version** of MLKit Barcode-scanning for Android. This version is downloaded on first use via Google Play Services. It increases the app size by around 600KB.

[You can read more about the difference between the two versions here.](https://developers.google.com/ml-kit/vision/barcode-scanning/android)

To use the **unbundled version** of the MLKit Barcode-scanning, add the following line to your `/android/gradle.properties` file:

```
dev.steenbakker.mobile_scanner.useUnbundled=true
```

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

## Web

As of version 5.0.0 adding the library to the `index.html` is no longer required,
as the library is automatically loaded on first use.

### Providing a mirror for the barcode scanning library

If a different mirror is needed to load the barcode scanning library,
the source URL can be set beforehand.

```dart
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final String scriptUrl = // ...

if (kIsWeb) {
  MobileScannerPlatform.instance.setBarcodeLibraryScriptUrl(scriptUrl);
}
```

## Usage ([ai_barcode_scanner](https://pub.dev/packages/ai_barcode_scanner))

Import `package:ai_barcode_scanner/ai_barcode_scanner.dart`, and use the widget with or without the controller.

If you don't provide a controller, you can't control functions like the torch(flash) or switching camera.

If you don't set allowDuplicates to false, you can get multiple scans in a very short time, causing things like pop() to fire lots of times.

```dart
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

/// Simple example of using the barcode scanner.
AiBarcodeScanner(
        onDetect: (BarcodeCapture barcodeCapture) {
          debugPrint(barcodeCapture);
        },
      ),

/// Example of using the barcode scanner with a controller.
AiBarcodeScanner(
        controller: MobileScannerController(
             detectionSpeed: DetectionSpeed.noDuplicates,
           ),
        onDetect: (BarcodeCapture barcodeCapture) {
          debugPrint(barcodeCapture);
        },
      ),

/// Example of using the barcode scanner with validation.
/// Validator works on the raw string, not the decoded value.
/// If you want to validate the scanner, use the [validate] parameter.
AiBarcodeScanner(
  onDispose: () {
    /// This is called when the barcode scanner is disposed.
    /// You can write your own logic here.
    debugPrint("Barcode scanner disposed!");
  },
  controller: MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  ),
  onDetect: (BarcodeCapture capture) {
    /// The row string scanned barcode value
    final String? scannedValue =
        capture.barcodes.first.rawValue;

    /// The `Uint8List` image is only available if `returnImage` is set to `true`.
    final Uint8List? image = capture.image;

    /// row data of the barcode
    final Object? raw = capture.raw;

    /// List of scanned barcodes if any
    final List<Barcode> barcodes = capture.barcodes;
  },
  validator: (value) {
    if (value.barcodes.isEmpty) {
      return false;
    }
    if (!(value.barcodes.first.rawValue
            ?.contains('flutter.dev') ??
        false)) {
      return false;
    }
    return true;
  },
),
```

## Usage ([mobile_scanner](https://pub.dev/packages/mobile_scanner))

Import the package with `package:mobile_scanner/mobile_scanner.dart`.

Create a new `MobileScannerController` controller, using the required options.
Provide a `StreamSubscription` for the barcode events.

```dart
final MobileScannerController controller = MobileScannerController(
  // required options for the scanner
);

StreamSubscription<Object?>? _subscription;
```

Ensure that your `State` class mixes in `WidgetsBindingObserver`, to handle lifecyle changes:

```dart
class MyState extends State<MyStatefulWidget> with WidgetsBindingObserver {
  // ...

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  // ...
}
```

Then, start the scanner in `void initState()`:

```dart
@override
void initState() {
  super.initState();
  // Start listening to lifecycle changes.
  WidgetsBinding.instance.addObserver(this);

  // Start listening to the barcode events.
  _subscription = controller.barcodes.listen(_handleBarcode);

  // Finally, start the scanner itself.
  unawaited(controller.start());
}
```

Finally, dispose of the the `MobileScannerController` when you are done with it.

```dart
@override
Future<void> dispose() async {
  // Stop listening to lifecycle changes.
  WidgetsBinding.instance.removeObserver(this);
  // Stop listening to the barcode events.
  unawaited(_subscription?.cancel());
  _subscription = null;
  // Dispose the widget itself.
  super.dispose();
  // Finally, dispose of the controller.
  await controller.dispose();
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

````dart
  /// Fit to screen
  final BoxFit fit;

  /// Barcode controller (optional)
  final MobileScannerController? controller;

  /// You can use your own custom overlay builder
  /// to build your own overlay
  /// This will override the default custom overlay
  final Widget? Function(BuildContext, bool?, MobileScannerController)?
      customOverlayBuilder;

  /// Overlay border color (default: white)
  final Color? borderColor;

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

  /// Show error or not (default: true)
  final bool showError;

  /// Error color (default: red)
  final Color errorColor;

  /// Show success or not (default: true)
  final bool showSuccess;

  /// Success color (default: green)
  final Color successColor;

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

  /// Called when this object is removed from the tree permanently.
  final void Function()? onDispose;

  /// AppBar widget
  /// you can use this to add appBar to the scanner screen
  ///
  final PreferredSizeWidget? Function(
      BuildContext context, MobileScannerController controller)? appBarBuilder;

  /// The builder for the bottom sheet.
  /// This is displayed below the camera preview.
  final Widget? Function(
          BuildContext context, MobileScannerController controller)?
      bottomSheetBuilder;

  /// The builder for the overlay above the camera preview.
  ///
  /// The resulting widget can be combined with the [scanWindow] rectangle
  /// to create a cutout for the camera preview.
  ///
  /// The [BoxConstraints] for this builder
  /// are the same constraints that are used to compute the effective [scanWindow].
  ///
  /// The overlay is only displayed when the camera preview is visible.
  final LayoutWidgetBuilder? overlayBuilder;

  /// The scan window rectangle for the barcode scanner.
  ///
  /// If this is not null, the barcode scanner will only scan barcodes
  /// which intersect this rectangle.
  ///
  /// This rectangle is relative to the layout size
  /// of the *camera preview widget* in the widget tree,
  /// rather than the actual size of the camera preview output.
  /// This is because the size of the camera preview widget
  /// might not be the same as the size of the camera output.
  ///
  /// For example, the applied [fit] has an effect on the size of the camera preview widget,
  /// while the camera preview size remains the same.
  ///
  /// The following example shows a scan window that is centered,
  /// fills half the height and one third of the width of the layout:
  ///
  /// ```dart
  /// LayoutBuider(
  ///   builder: (BuildContext context, BoxConstraints constraints) {
  ///     final Size layoutSize = constraints.biggest;
  ///
  ///     final double scanWindowWidth = layoutSize.width / 3;
  ///     final double scanWindowHeight = layoutSize.height / 2;
  ///
  ///     final Rect scanWindow = Rect.fromCenter(
  ///       center: layoutSize.center(Offset.zero),
  ///       width: scanWindowWidth,
  ///       height: scanWindowHeight,
  ///     );
  ///   }
  /// );
  /// ```
  final Rect? scanWindow;

  /// The threshold for updates to the [scanWindow].
  ///
  /// If the [scanWindow] would be updated,
  /// due to new layout constraints for the scanner,
  /// and the width or height of the new scan window have not changed by this threshold,
  /// then the scan window is not updated.
  ///
  /// It is recommended to set this threshold
  /// if scan window updates cause performance issues.
  ///
  /// Defaults to no threshold for scan window updates.
  ///
  final void Function(BarcodeCapture)? onDetect;

  /// The threshold for updates to the [scanWindow].
  ///
  /// If the [scanWindow] would be updated,
  /// due to new layout constraints for the scanner,
  /// and the width or height of the new scan window have not changed by this threshold,
  /// then the scan window is not updated.
  ///
  /// It is recommended to set this threshold
  /// if scan window updates cause performance issues.
  ///
  /// Defaults to no threshold for scan window updates.
  final double scanWindowUpdateThreshold;

  /// Validator function to check if barcode is valid or not
  final bool Function(BarcodeCapture)? validator;

  final void Function(String?)? onImagePick;

  /// Title for the draggable sheet (default: 'Scan any QR code')
  final String sheetTitle;

  /// Child widget for the draggable sheet (default: SizedBox.shrink())
  final Widget sheetChild;

  /// Hide drag handler of the draggable sheet (default: false)
  final bool hideSheetDragHandler;

  /// Hide title of the draggable sheet (default: false)
  final bool hideSheetTitle;

  /// Hide gallery button (default: false)
  /// This will hide the gallery button at the bottom of the screen
  final bool hideGalleryButton;

  /// Hide gallery icon (default: false)
  /// This will hide the gallery icon in the app bar
  final bool hideGalleryIcon;

  /// Extend body behind app bar (default: true)
  final bool extendBodyBehindAppBar;

  /// Upload from gallery button alignment
  /// default: bottom center, center, 0.75
  final AlignmentGeometry? galleryButtonAlignment;

  /// actions for the app bar (optional)
  /// Camera switch and torch toggle buttons are added by default
  /// You can add more actions to the app bar using this parameter
  final List<Widget>? actions;
````

### Contributing to [ai_barcode_scanner](https://pub.dev/packages/ai_barcode_scanner)

All contributions are welcome. Let's make this package better together.

## Thanks to all the contributors and supporters.

### Contributors

<a href="https://github.com/mohesu/barcode_scanner/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=mohesu/barcode_scanner" />
</a>

Made with [contrib.rocks](https://contrib.rocks).

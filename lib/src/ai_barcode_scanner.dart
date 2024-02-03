import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'overlay.dart';

/// Barcode scanner widget
class AiBarcodeScanner extends StatefulWidget {
  /// Function that gets Called when barcode is scanned successfully
  ///
  final void Function(String) onScan;

  /// Function that gets called when a Barcode is detected.
  ///
  /// [barcode] The barcode object with all information about the scanned code.
  /// [args] Information about the state of the MobileScanner widget
  final void Function(BarcodeCapture)? onDetect;

  /// Validate barcode text with a function
  final bool Function(String value)? validator;

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
  /// If you want to replace the bottom screen widget, use [bottomBar]
  final Widget? bottomBar;

  /// Hint text (default: 'Scan QR Code')
  final String bottomBarText;

  /// Hint text style
  final TextStyle bottomBarTextStyle;

  /// Show error or not (default: true)
  final bool showError;

  /// Error color (default: red)
  final Color errorColor;

  /// Show success or not (default: true)
  final bool showSuccess;

  /// Success color (default: green)
  final Color successColor;

  /// A toggle to enable or disable haptic feedback upon scan (default: true)
  final bool hapticFeedback;

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

  /// Appbar widget
  /// you can use this to add appbar to the scanner screen
  ///
  final PreferredSizeWidget? appBar;

  const AiBarcodeScanner({
    Key? key,
    required this.onScan,
    this.validator,
    this.fit = BoxFit.cover,
    this.controller,
    this.onDetect,
    this.borderColor = Colors.white,
    this.borderWidth = 10,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 10,
    this.borderLength = 40,
    this.cutOutSize = 300,
    this.cutOutWidth,
    this.cutOutHeight,
    this.cutOutBottomOffset = 0,
    this.bottomBarText = 'Scan QR Code',
    this.bottomBarTextStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.showOverlay = true,
    this.showError = true,
    this.errorColor = Colors.red,
    this.showSuccess = true,
    this.successColor = Colors.green,
    this.hapticFeedback = true,
    this.canPop = true,
    this.errorBuilder,
    this.placeholderBuilder,
    this.onScannerStarted,
    this.onDispose,
    this.scanWindow,
    this.startDelay,
    this.bottomBar,
    this.appBar,
  }) : super(key: key);

  @override
  State<AiBarcodeScanner> createState() => _AiBarcodeScannerState();
}

class _AiBarcodeScannerState extends State<AiBarcodeScanner> {
  /// bool to check if barcode is valid or not
  bool? _isSuccess;

  /// Scanner controller
  late MobileScannerController controller;

  @override
  void initState() {
    controller = widget.controller ?? MobileScannerController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();

    /// calls onDispose function if it is not null
    if (widget.onDispose != null) {
      widget.onDispose!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    // /// keeps the app in portrait mode
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          bottomNavigationBar: orientation == Orientation.portrait
              ? widget.bottomBar ??
                  ListTile(
                    leading: Builder(
                      builder: (context) {
                        return IconButton(
                          tooltip: "Switch Camera",
                          onPressed: () => controller.switchCamera(),
                          icon: ValueListenableBuilder<CameraFacing>(
                            valueListenable: controller.cameraFacingState,
                            builder: (context, state, child) {
                              switch (state) {
                                case CameraFacing.front:
                                  return const Icon(Icons.camera_front);
                                case CameraFacing.back:
                                  return const Icon(Icons.camera_rear);
                              }
                            },
                          ),
                        );
                      },
                    ),
                    title: Text(
                      widget.bottomBarText,
                      textAlign: TextAlign.center,
                      style: widget.bottomBarTextStyle,
                    ),
                    trailing: Builder(
                      builder: (context) {
                        return IconButton(
                          tooltip: "Torch",
                          onPressed: () => controller.toggleTorch(),
                          icon: ValueListenableBuilder<TorchState>(
                            valueListenable: controller.torchState,
                            builder: (context, state, child) {
                              switch (state) {
                                case TorchState.off:
                                  return const Icon(Icons.flash_off);
                                case TorchState.on:
                                  return const Icon(Icons.flash_on);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  )
              : null,
          appBar: widget.appBar,
          body: Stack(
            children: [
              MobileScanner(
                controller: controller,
                fit: widget.fit,
                errorBuilder: widget.errorBuilder,
                onScannerStarted: widget.onScannerStarted,
                placeholderBuilder: widget.placeholderBuilder,
                scanWindow: widget.scanWindow,
                startDelay: widget.startDelay ?? false,
                key: widget.key,
                onDetect: (BarcodeCapture barcode) async {
                  widget.onDetect?.call(barcode);

                  if (barcode.barcodes.isEmpty) {
                    log('Scanned Code is Empty');
                    return;
                  }

                  final String code = barcode.barcodes.first.rawValue ?? "";

                  if ((widget.validator != null && !widget.validator!(code))) {
                    setState(() {
                      if (widget.hapticFeedback) HapticFeedback.heavyImpact();
                      log('Invalid Barcode => $code');
                      _isSuccess = false;
                    });
                    return;
                  }
                  setState(() {
                    _isSuccess = true;
                    if (widget.hapticFeedback) HapticFeedback.lightImpact();
                    log('Barcode rawValue => $code');
                    widget.onScan(code);
                  });
                  if (widget.canPop && mounted && Navigator.canPop(context)) {
                    Navigator.pop(context);
                    return;
                  }
                },
              ),
              if (widget.showOverlay)
                Container(
                  decoration: ShapeDecoration(
                    shape: OverlayShape(
                      borderRadius: widget.borderRadius,
                      borderColor: ((_isSuccess ?? false) && widget.showSuccess)
                          ? widget.successColor
                          : (!(_isSuccess ?? true) && widget.showError)
                              ? widget.errorColor
                              : widget.borderColor,
                      borderLength: widget.borderLength,
                      borderWidth: widget.borderWidth,
                      cutOutSize: widget.cutOutSize,
                      cutOutBottomOffset: widget.cutOutBottomOffset,
                      cutOutWidth: widget.cutOutWidth,
                      cutOutHeight: widget.cutOutHeight,
                      overlayColor:
                          ((_isSuccess ?? false) && widget.showSuccess)
                              ? widget.successColor.withOpacity(0.4)
                              : (!(_isSuccess ?? true) && widget.showError)
                                  ? widget.errorColor.withOpacity(0.4)
                                  : widget.overlayColor,
                    ),
                  ),
                ),
              if (orientation == Orientation.landscape)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          tooltip: "Switch Camera",
                          onPressed: () => controller.switchCamera(),
                          icon: ValueListenableBuilder<CameraFacing>(
                            valueListenable: controller.cameraFacingState,
                            builder: (context, state, child) {
                              switch (state) {
                                case CameraFacing.front:
                                  return const Icon(Icons.camera_front);
                                case CameraFacing.back:
                                  return const Icon(Icons.camera_rear);
                              }
                            },
                          ),
                        ),
                        IconButton(
                          tooltip: "Torch",
                          onPressed: () => controller.toggleTorch(),
                          icon: ValueListenableBuilder<TorchState>(
                            valueListenable: controller.torchState,
                            builder: (context, state, child) {
                              switch (state) {
                                case TorchState.off:
                                  return const Icon(Icons.flash_off);
                                case TorchState.on:
                                  return const Icon(Icons.flash_on);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}

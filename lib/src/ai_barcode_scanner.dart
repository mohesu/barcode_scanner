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

  const AiBarcodeScanner({
    Key? key,
    required this.onScan,
    this.validator,
    this.allowDuplicates = false,
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
    this.hintText = 'Scan QR Code',
    this.hintMargin = const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
    this.hintBackgroundColor = Colors.white,
    this.hintTextStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.hintPadding = const EdgeInsets.all(0),
    this.showOverlay = true,
    this.showError = true,
    this.errorColor = Colors.red,
    this.errorText = 'Invalid BarCode',
    this.showSuccess = true,
    this.successColor = Colors.green,
    this.successText = 'BarCode Found',
    this.canPop = true,
    this.errorBuilder,
    this.placeholderBuilder,
    this.onScannerStarted,
    this.onDispose,
    this.scanWindow,
    this.startDelay,
    this.hintWidget,
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
  Widget build(BuildContext context) {
    /// keeps the app in portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            fit: widget.fit,
            errorBuilder: widget.errorBuilder ??
                (context, error, child) {
                  return const ColoredBox(
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.no_photography,
                            color: Colors.white,
                            size: 100,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Failed to load camera.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                  HapticFeedback.heavyImpact();
                  log('Invalid Barcode => $code');
                  _isSuccess = false;
                });
                return;
              }
              setState(() {
                _isSuccess = true;
                HapticFeedback.lightImpact();
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
                  overlayColor: ((_isSuccess ?? false) && widget.showSuccess)
                      ? widget.successColor.withOpacity(0.4)
                      : (!(_isSuccess ?? true) && widget.showError)
                          ? widget.errorColor.withOpacity(0.4)
                          : widget.overlayColor,
                ),
              ),
            ),
          widget.hintWidget ??
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Container(
                      margin: widget.hintMargin,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        color: widget.hintBackgroundColor,
                      ),
                      child: ListTile(
                        contentPadding: widget.hintPadding,
                        leading: IconButton(
                          color: Theme.of(context).primaryColor,
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
                        title: Text(
                          widget.hintText,
                          textAlign: TextAlign.center,
                          style: widget.hintTextStyle,
                        ),
                        trailing: IconButton(
                          tooltip: "Torch",
                          onPressed: () => controller.toggleTorch(),
                          icon: ValueListenableBuilder<TorchState>(
                            valueListenable: controller.torchState,
                            builder: (context, state, child) {
                              switch (state) {
                                case TorchState.off:
                                  return const Icon(
                                    Icons.flash_off,
                                    color: Colors.grey,
                                  );
                                case TorchState.on:
                                  return const Icon(
                                    Icons.flash_on,
                                    color: Colors.orange,
                                  );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
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
  void initState() {
    controller = widget.controller ?? MobileScannerController();
    super.initState();
  }
}

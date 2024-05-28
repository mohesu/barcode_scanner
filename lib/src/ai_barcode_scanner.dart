import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'draggable_sheet.dart';
import 'error_builder.dart';
import 'gallery_button.dart';
import 'overlay.dart';

/// Barcode scanner widget
class AiBarcodeScanner extends StatefulWidget {
  /// Fit to screen
  final BoxFit fit;

  /// Barcode controller (optional)
  final MobileScannerController? controller;

  /// Show overlay or not (default: true)
  final bool showOverlay;

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
  final PreferredSizeWidget? appBar;

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
  final String title;

  /// Child widget for the draggable sheet (default: SizedBox.shrink())
  final Widget child;

  /// Hide drag handler of the draggable sheet (default: false)
  final bool hideDragHandler;

  /// Hide title of the draggable sheet (default: false)
  final bool hideTitle;

  /// Upload from gallery button alignment
  /// default: bottom center, center, 0.75
  final AlignmentGeometry? buttonAlignment;

  /// actions for the app bar (optional)
  /// Camera switch and torch toggle buttons are added by default
  /// You can add more actions to the app bar using this parameter
  final List<Widget>? actions;

  /// Show button that allows the user to pick an image from the gallery or not (default: true)
  final bool showGalleryButton;

  /// Optional function to be called when clicking the back button on the app bar
  /// If not provided, the default behavior is to pop the current route from the navigator
  final void Function()? onPop;
  const AiBarcodeScanner({
    super.key,
    this.fit = BoxFit.cover,
    this.controller,
    this.borderColor,
    this.cutOutWidth,
    this.cutOutHeight,
    this.borderWidth = 12,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 82),
    this.borderRadius = 24,
    this.borderLength = 42,
    this.cutOutSize = 352,
    this.cutOutBottomOffset = 124,
    this.scanWindowUpdateThreshold = 0.0,
    this.showOverlay = true,
    this.showError = true,
    this.showSuccess = true,
    this.errorColor = Colors.red,
    this.successColor = Colors.green,
    this.errorBuilder,
    this.placeholderBuilder,
    this.onDispose,
    this.scanWindow,
    this.appBar,
    this.overlayBuilder,
    this.onDetect,
    this.validator,
    this.onImagePick,
    this.title = 'Scan any QR code',
    this.child = const SizedBox.shrink(),
    this.hideDragHandler = false,
    this.hideTitle = false,
    this.buttonAlignment,
    this.actions,
    this.onPop,
    this.showGalleryButton = true,
  });

  @override
  State<AiBarcodeScanner> createState() => _AiBarcodeScannerState();
}

class _AiBarcodeScannerState extends State<AiBarcodeScanner> {
  /// bool to check if barcode is valid or not
  final ValueNotifier<bool?> _isSuccess = ValueNotifier<bool?>(null);

  /// Scanner controller
  late MobileScannerController controller;

  double _cutOutBottomOffset = 0;

  @override
  void initState() {
    controller = widget.controller ?? MobileScannerController();
    _cutOutBottomOffset = widget.cutOutBottomOffset;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    widget.controller?.dispose();
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        if (isLandscape) {
          _cutOutBottomOffset = 0;
        } else {
          _cutOutBottomOffset = widget.cutOutBottomOffset;
        }
        return Scaffold(
          appBar: widget.appBar ??
              AppBar(
                leading: Navigator.canPop(context)
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: widget.onPop ?? () => Navigator.pop(context),
                      )
                    : null,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.cameraswitch_rounded),
                    onPressed: () => controller.switchCamera(),
                  ),
                  IconButton(
                    icon: controller.torchEnabled
                        ? const Icon(Icons.flashlight_off_rounded)
                        : const Icon(Icons.flashlight_on_rounded),
                    onPressed: () => controller.toggleTorch(),
                  ),
                  if (isLandscape && widget.showGalleryButton)
                    GalleryButton.icon(
                      onImagePick: widget.onImagePick,
                      onDetect: widget.onDetect,
                      validator: widget.validator,
                      controller: controller,
                      isSuccess: _isSuccess,
                    ),
                  ...?widget.actions,
                ],
              ),
          extendBodyBehindAppBar: true,
          bottomSheet: isLandscape
              ? null
              : DraggableSheet(
                  title: widget.title,
                  hideDragHandler: widget.hideDragHandler,
                  hideTitle: widget.hideTitle,
                  child: widget.child,
                ),
          body: Stack(
            children: [
              MobileScanner(
                onDetect: onDetect,
                controller: controller,
                fit: widget.fit,
                errorBuilder: widget.errorBuilder ??
                    (_, error, ___) => const ErrorBuilder(),
                placeholderBuilder: widget.placeholderBuilder,
                scanWindow: widget.scanWindow,
                key: widget.key,
                overlayBuilder: widget.overlayBuilder,
                scanWindowUpdateThreshold: widget.scanWindowUpdateThreshold,
              ),
              if (widget.showOverlay)
                ValueListenableBuilder<bool?>(
                  valueListenable: _isSuccess,
                  builder: (context, isSuccess, __) {
                    return Container(
                      decoration: ShapeDecoration(
                        shape: OverlayShape(
                          borderRadius: widget.borderRadius,
                          borderColor:
                              ((isSuccess ?? false) && widget.showSuccess)
                                  ? widget.successColor
                                  : (!(isSuccess ?? true) && widget.showError)
                                      ? widget.errorColor
                                      : widget.borderColor ?? Colors.white,
                          borderLength: widget.borderLength,
                          borderWidth: widget.borderWidth,
                          cutOutSize: widget.cutOutSize,
                          cutOutBottomOffset: _cutOutBottomOffset,
                          cutOutWidth: widget.cutOutWidth,
                          cutOutHeight: widget.cutOutHeight,
                          overlayColor:
                              ((isSuccess ?? false) && widget.showSuccess)
                                  ? widget.successColor.withOpacity(0.4)
                                  : (!(isSuccess ?? true) && widget.showError)
                                      ? widget.errorColor.withOpacity(0.4)
                                      : widget.overlayColor,
                        ),
                      ),
                    );
                  },
                ),
              if (!isLandscape && widget.showGalleryButton)
                Align(
                  alignment: widget.buttonAlignment ??
                      Alignment.lerp(
                        Alignment.bottomCenter,
                        Alignment.center,
                        0.75,
                      )!,
                  child: GalleryButton(
                    onImagePick: widget.onImagePick,
                    onDetect: widget.onDetect,
                    validator: widget.validator,
                    controller: controller,
                    isSuccess: _isSuccess,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void onDetect(BarcodeCapture barcodes) {
    widget.onDetect?.call(barcodes);
    if (widget.validator != null) {
      final isValid = widget.validator!(barcodes);
      if (!isValid) {
        HapticFeedback.heavyImpact();
      }
      HapticFeedback.mediumImpact();
      _isSuccess.value = isValid;
    }
  }
}

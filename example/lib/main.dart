import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String barcode = 'Tap  to scan';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('Scan Barcode'),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AiBarcodeScanner(
                      onDispose: () {
                        /// This is called when the barcode scanner is disposed.
                        /// You can write your own logic here.
                        debugPrint("Barcode scanner disposed!");
                      },
                      hideGalleryButton: false,
                      controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.noDuplicates,
                      ),
                      onDetect: (BarcodeCapture capture) {
                        /// The row string scanned barcode value
                        final String? scannedValue =
                            capture.barcodes.first.rawValue;
                        debugPrint("Barcode scanned: $scannedValue");

                        /// The `Uint8List` image is only available if `returnImage` is set to `true`.
                        final Uint8List? image = capture.image;
                        debugPrint("Barcode image: $image");

                        /// row data of the barcode
                        final Object? raw = capture.raw;
                        debugPrint("Barcode raw: $raw");

                        /// List of scanned barcodes if any
                        final List<Barcode> barcodes = capture.barcodes;
                        debugPrint("Barcode list: $barcodes");
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
                  ),
                );
              },
            ),
            Text(barcode),
          ],
        ),
      ),
    );
  }
}

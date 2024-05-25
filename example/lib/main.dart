import 'dart:developer';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
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
                        debugPrint("Barcode scanner disposed!");
                      },
                      controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.noDuplicates,
                      ),
                      onDetect: (p0) => setState(() {
                        barcode = p0.barcodes.first.rawValue.toString();
                        log(barcode, name: 'Barcode');
                      }),
                      validator: (p0) =>
                          p0.barcodes.first.rawValue?.startsWith('https://') ??
                          false,
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

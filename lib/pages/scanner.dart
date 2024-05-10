import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:io';

import 'trails_widgets.dart';
import '../generic_functions.dart';
import '../generic_widgets.dart';
import '../documents_path.dart';


class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(true),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              style: compactButton(),
              // Upon tapping the button, navigate to the QR code scanner
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Scanner(),
                  )
                );
              },
              child: const Text('Scan a QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}


class Scanner extends StatelessWidget {
  const Scanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(false),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        // Scan
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          String scan = barcodes[0].rawValue!;
          // Close the QR code scanner
          Navigator.pop(context);
          // Navigate to the trail stop
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScannerStopPage(scanData: scan),
            )
          );
        }
      )
    );
  }
}


class ScannerStopPage extends StatefulWidget {
  final String scanData;
  const ScannerStopPage({super.key, required this.scanData});

  @override
  State<ScannerStopPage> createState() => _ScannerStopPageState();
}


class _ScannerStopPageState extends State<ScannerStopPage> {
  int trailNumber = 0;
  int stopNumber = 0;
  String selectedDirectory = '';
  String filePath = '';
  dynamic trailStop;
  bool loading = true;

  Future<void> getCodeInformation() async {
    trailNumber = int.parse(widget.scanData.split('-')[0]);
    stopNumber = int.parse(widget.scanData.split('-')[1]);
  }

  // Select either application documents or assets
  Future<void> selectDirectory() async {
    // If the file exists in application documents, select application documents
    if (File('$documentsPath/trails/trail$trailNumber/trail.json').existsSync()) {
      selectedDirectory = documentsPath;
    }
    // Otherwise, select assets
    else {
      selectedDirectory = 'assets';
    }
    filePath = '$selectedDirectory/trails/trail$trailNumber/trail.json';
  }
  
  // Read the trail's JSON file
  Future<void> readTrailStops() async {
    dynamic data;
    // If the application directory is in use, the JSON file isn't bundled
    if (selectedDirectory == documentsPath) {
      data = await readJSON(filePath);
    }
    // Otherwise, assets is in use, and the JSON file is bundled
    else {
      data = await readBundledJSON(filePath);
    }
    try {
      trailStop = data['trailStops'][stopNumber];
    }
    catch (e) {
      trailStop = null;
    }
  }

  Future<void> readContent() async {
    try {
      await getCodeInformation();
      await selectDirectory();
      await readTrailStops();
    }
    catch (e) {
      trailStop = null;
    }
    setState(() {});
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    readContent();

    // If the content is loading, display an empty page
    if (loading) {
      return Scaffold(
        appBar: appBar(true)
      );
    }
    // If the file doesn't exist, display an empty page
    if (trailStop == null) {
      return Scaffold(
        appBar: appBar(false),
        body: emptyPage('This trail stop isn\'t currently available.')
      );
    }

    // Otherwise, display content
    return Scaffold(
      appBar: appBar(false), 
      body: Column(
        children: [
          trailStop['is_audio']
          ? trailStopAudioCard(trailNumber, trailStop, context, selectedDirectory) 
          : trailStopCard(trailNumber, trailStop, selectedDirectory)
        ]
      )
    );
  }
}

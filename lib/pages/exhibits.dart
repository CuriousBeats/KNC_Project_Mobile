import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:io';

import '../generic_functions.dart';
import '../generic_widgets.dart';
import '../documents_path.dart';


class ExhibitsPage extends StatefulWidget {
  const ExhibitsPage({super.key});

  @override
  State<ExhibitsPage> createState() => _ExhibitsPageState();
}


class _ExhibitsPageState extends State<ExhibitsPage> {
  List exhibits = [];
  dynamic exhibit;
  String filePath = '';
  String selectedDirectory = '';
  bool loading = true;

  // Select either application documents or assets
  Future<void> selectDirectory() async {
    // If the file exists in application documents, select application documents
    if (File('$documentsPath/exhibits/exhibits.json').existsSync()) {
        selectedDirectory = documentsPath;
    }
    // Otherwise, select assets
    else {
        selectedDirectory = 'assets';
    }
    filePath = '$selectedDirectory/exhibits/exhibits.json';
  }

  // Read exhibits.json
  Future<void> readExhibits() async {
    dynamic data;
    // If the application directory is in use, the JSON file isn't bundled
    if (selectedDirectory == documentsPath) {
      data = await readJSON(filePath);
    }
    // Otherwise, assets is in use, and the JSON file is bundled
    else {
      data = await readBundledJSON(filePath);
      try {
        exhibits = data['exhibits'];
        exhibit = exhibits[0];
      }
      catch (e) {
        exhibits = [];
        exhibit = null;
      }
    }
  }

  Future<void> readContent() async {
    await selectDirectory();
    await readExhibits();
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
    if (exhibits.isEmpty || exhibit == null) {
      return Scaffold(
        appBar: appBar(true)
      );
    }

    // Otherwise, display content
    return Scaffold(
      appBar: appBar(true),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              style: compactButton(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExhibitPDF(exhibitFilePath: '$selectedDirectory/exhibits/pdfs/${exhibit['pdfs'][0]}', selectedDirectory: selectedDirectory),
                  )
                );
              },
              child: const Text('Current Exhibit'),
            ),
          ],
        ),
      ),
    );
  }
}


class ExhibitPDF extends StatelessWidget {
  final String exhibitFilePath;
  final String selectedDirectory;
  const ExhibitPDF({super.key, required this.exhibitFilePath, required this.selectedDirectory});

  @override
  Widget build(BuildContext context) {
    if (selectedDirectory == 'assets') {
      final PdfController pdfController = PdfController(
        document: PdfDocument.openAsset(exhibitFilePath),
      );
      return Scaffold(
        appBar: appBar(false),
        body: PdfView(
          controller: pdfController,
          scrollDirection: Axis.vertical,
        ),
      );
    }
    else {
      final PdfController pdfController = PdfController(
        document: PdfDocument.openFile(exhibitFilePath),
      );
      return Scaffold(
        appBar: appBar(false),
        body: PdfView(
          controller: pdfController,
          scrollDirection: Axis.vertical,
        ),
      );
    }
  }
}

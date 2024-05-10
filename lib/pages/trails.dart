import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import 'trails_widgets.dart';
import '../colors.dart';
import '../documents_path.dart';
import '../generic_functions.dart';
import '../generic_widgets.dart';


class TrailsPage extends StatefulWidget {
  const TrailsPage({super.key});

  @override
  State<TrailsPage> createState() => _TrailsPageState();
}


class _TrailsPageState extends State<TrailsPage> {
  String selectedDirectory = '';
  String filePath = '';
  List trails = [];
  bool loading = true;

  // Select either application documents or assets
  Future<void> selectDirectory() async {   
    // If the file exists in application documents, select application documents
    if (File('$documentsPath/trails/trails.json').existsSync()) {
      selectedDirectory = documentsPath;
    }
    // Otherwise, select assets
    else {
      selectedDirectory = 'assets';    
    }
    filePath = '$selectedDirectory/trails/trails.json';
  }

  // Read trails.json
  Future<void> readTrails() async {
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
      trails = data['trails'];
    }
    catch (e) {
      trails = [];
    }
  }

  Future<void> readContent() async {
    await selectDirectory();
    await readTrails();
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

    // If the files don't exist, display an empty page
    if (trails.isEmpty) {
      return Scaffold(
        appBar: appBar(true),
        body: emptyPage('No trails are currently available.')
      );
    }

    // Otherwise, display content
    return Scaffold(
      appBar: appBar(true), 
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: trails.length + 1,
              itemBuilder: (context, trailNumber) {
                if (trailNumber == 0) {
                  return viewTrailMapCard(context, selectedDirectory);
                }
                else {
                  dynamic trail = trails[trailNumber - 1];
                  return trailCard(trailNumber - 1, trail, context, selectedDirectory);
                }
              },
            ),
          ),
        ],
      )
    );
  }
}


class TrailStopsPage extends StatefulWidget {
  final int trailNumber;
  const TrailStopsPage({super.key, required this.trailNumber});

  @override
  State<TrailStopsPage> createState() => _TrailStopsPageState();
}


class _TrailStopsPageState extends State<TrailStopsPage> {
  String selectedDirectory = '';
  String filePath = '';
  List trailStops = [];
  bool loading = true;

  // Select either application documents or assets
  Future<void> selectDirectory() async {
    // If the file exists in application documents, select application documents
    if (File('$documentsPath/trails/trail${widget.trailNumber}/trail.json').existsSync()) {
      selectedDirectory = documentsPath;
    }
    // Otherwise, select assets
    else {
      selectedDirectory = 'assets';  
    }
    filePath = '$selectedDirectory/trails/trail${widget.trailNumber}/trail.json';
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
      trailStops = data['trailStops'];
    }
    catch (e) {
      trailStops = [];
    }
  }

  Future<void> readContent() async {
    await selectDirectory();
    await readTrailStops();
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
    if (trailStops.isEmpty) {
      return Scaffold(
        appBar: appBar(false),
        body: emptyPage('This trail doesn\'t currently have any trail stops.')
      );
    }

    // Otherwise, display content
    return Scaffold(
      appBar: appBar(false), 
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: trailStops.length,
              itemBuilder: (context, trailStopNumber) {
                dynamic trailStop = trailStops[trailStopNumber];
                if (trailStop['is_audio']) {
                  return trailStopAudioCard(widget.trailNumber, trailStop, context, selectedDirectory);
                }
                else {
                  return trailStopCard(widget.trailNumber, trailStop, selectedDirectory);
                }
              },
            ),
          ),
        ],
      )
    );
  }
}


class TrailStopAudioPage extends StatefulWidget {
  final Widget trailStopImage;
  final Widget trailStopTitle;
  final String trailStopAudioPath;
  final String selectedDirectory;
  const TrailStopAudioPage({
    super.key, 
    required this.trailStopImage, 
    required this.trailStopTitle, 
    required this.trailStopAudioPath,
    required this.selectedDirectory
  });

  @override
  State<TrailStopAudioPage> createState() => _TrailStopAudioPageState();
}


class _TrailStopAudioPageState extends State<TrailStopAudioPage> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // Stop playing audio upon leaving the page
  @override
  void dispose() {
    super.dispose();
    player.stop();
  }

  @override
  void initState() {
    super.initState();
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
        player.resume();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(false), 
      body: Column(
        children: [
          Card(
            color: lightBrown,
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  widget.trailStopImage,
                  // Title
                  Center(child:
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                      child: widget.trailStopTitle,
                    )
                  ),
                  // Play/pause button
                  Center(
                    child: ElevatedButton(
                      style: compactButton(),
                      onPressed: () {
                        if (isPlaying) {
                          player.pause();
                        }
                        else {
                          if (widget.selectedDirectory == 'assets') {
                            player.play(AssetSource(widget.trailStopAudioPath));
                          }
                          else {
                            player.play(DeviceFileSource('${widget.selectedDirectory}/${widget.trailStopAudioPath}'));
                          }
                        }
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                      child: Icon(isPlaying ? Icons.pause : Icons.play_arrow)
                    )
                  ),
                  // Progress slider
                  Slider( 
                    activeColor: pineGreen,
                    min: 0, 
                    max: duration.inSeconds.toDouble(), 
                    value: position.inSeconds.toDouble(), 
                    onChanged: (value){
                      final position = Duration(seconds: value.toInt());
                      player.seek(position);
                      player.resume;
                  }),
                  // Time passed/left
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(position)),
                      Text(formatTime(duration - position))
                    ]
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}


class TrailMapPDF extends StatelessWidget {
  final String selectedDirectory;
  const TrailMapPDF({super.key, required this.selectedDirectory});

  @override
  Widget build(BuildContext context) {
    if (selectedDirectory == 'assets') {
      final PdfController pdfController = PdfController(
        document: PdfDocument.openAsset('$selectedDirectory/trails/trail_map.pdf'),
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
        document: PdfDocument.openFile('$selectedDirectory/trails/trail_map.pdf'),
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

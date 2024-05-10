import 'dart:io';
import 'package:flutter/material.dart';

import 'home_widgets.dart';
import '../colors.dart';
import '../documents_path.dart';
import '../generic_functions.dart';
import '../generic_widgets.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  String selectedDirectory = '';
  String filePathAnnouncements = '';
  String filePathEvents = '';
  List announcements = [];
  List events = [];
  bool loading = true;

  // Select either application documents or assets
  Future<void> selectDirectory() async {
    // If the files exist in application documents, select application documents
    if (File('$documentsPath/announcements/announcements.json').existsSync() && File('$documentsPath/events/events.json').existsSync()) {
      selectedDirectory = documentsPath;
    }
    // Otherwise, select assets
    else {
      selectedDirectory = 'assets';
    }
    filePathAnnouncements = '$selectedDirectory/announcements/announcements.json';
    filePathEvents = '$selectedDirectory/events/events.json';
  }

  // Read announcements.json
  Future<void> readAnnouncements() async {
    dynamic data;
    // If the application directory is in use, the JSON file isn't bundled
    if (selectedDirectory == documentsPath) {
      data = await readJSON(filePathAnnouncements);
    }
    // Otherwise, assets is in use, and the JSON file is bundled
    else {
      data = await readBundledJSON(filePathAnnouncements);
    }
    try {
      announcements = data['announcements'];
    }
    catch (e) {
      announcements = [];
    }
  }

  // Read events.json
  Future<void> readEvents() async {
    dynamic data;
    // If the application directory is in use, the JSON file isn't bundled
    if (selectedDirectory == documentsPath) {
      data = await readJSON(filePathEvents);
    }
    // Otherwise, assets is in use, and the JSON file is bundled
    else {
      data = await readBundledJSON(filePathEvents);
    }
    try {
      events = data['events'];
    }
    catch (e) {
      events = [];
    }
  }

  Future<void> readContent() async {
    await selectDirectory();
    await readAnnouncements();
    await readEvents();
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
    if (announcements.isEmpty || events.isEmpty) {
      return Scaffold(
        appBar: appBar(true),
        body: emptyPage('No announcements or events are currently available.')
      );
    }
    
    // Otherwise, display content
    return Scaffold(
      appBar: appBar(true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: announcements.length + events.length + 2,
              itemBuilder: (context, index) {
                // Announcements divider
                if (index == 0) {
                  return divider('Announcements', Colors.black, lightBlue);
                }
                // Announcements
                else if (index < announcements.length+1) {
                  dynamic announcement = announcements[index-1];
                  String imagePath = '$selectedDirectory/announcements/images/${announcement['images'][0]}';
                  return announcementCard(announcement, imagePath, selectedDirectory);
                }
                // Events divider
                else if (index == announcements.length+1) {
                  return divider('Events', Colors.black, lightBrown);
                }
                // Events
                else {
                  dynamic event = events[index-announcements.length-2];
                  String imagePath = '$selectedDirectory/events/images/${event['images'][0]}';
                  return eventCard(event, imagePath, selectedDirectory);
                }                 
              },
            ),
          ),
        ],
      )
    );
  }
}

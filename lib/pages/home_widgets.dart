import 'package:flutter/material.dart';

import '../colors.dart';
import '../generic_widgets.dart';


Widget announcementCard(final announcement, final imagePath, String selectedDirectory) {
  final announcementImage = fullImage(imagePath, selectedDirectory);
  final announcementTitle = titleSmall(announcement['title']);
  final announcementSubtitle = subtitle(announcement['subtitle1']);
  final announcementDescription = description(announcement['description']);

  return Card(
    color: lightBlue,
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          announcementImage,
          // Title
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: announcementTitle,
          ),
          // Subtitle
          announcement['subtitle1']!=''? Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: announcementSubtitle,
          ): Container(),
          // Description
          announcementDescription,
        ],
      ),
    )
  );
}


Widget eventCard(final event, final imagePath, String selectedDirectory) {
  final eventImage = fullImage(imagePath, selectedDirectory);
  final eventTitle = titleSmall(event['title']);
  final eventSubtitle = subtitle(event['day'] + ' ' + event['month'] + ' ' + event['year'] + ' | ' + event['startTime'] + ' - ' + event['endTime']);
  final eventDescription = description(event['location']);

  return Card(
    color: lightBrown,
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          eventImage,
          // Title
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: eventTitle,
          ),
          // Date and time
          eventSubtitle,
          // Location
          eventDescription,
        ],
      ),
    )
  );
}

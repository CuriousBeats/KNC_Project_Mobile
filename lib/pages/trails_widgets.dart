import 'package:flutter/material.dart';

import 'trails.dart';
import '../colors.dart';
import '../generic_widgets.dart';


Widget trailCard(final trailNumber, final trail, context, String selectedDirectory) {
  final trailImage = fullImage('$selectedDirectory/trails/images/$trailNumber.jpg', selectedDirectory);
  final trailTitle = titleSmall(trail['name']);
  final trailSubtitle = subtitle(trail['length'] + ' miles | ' + trail['difficulty']);
  final trailDescription = description(trail['description']);

  return InkWell(
    // Upon tapping a trail, navigate to its trail stops
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrailStopsPage(trailNumber: trailNumber),
        )
      );
    },
    child: Card(
      color: lightYellow,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            trailImage,
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: trailTitle,
            ),
            // Subtitle
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: trailSubtitle,
            ),
            // Description
            trailDescription,
          ],
        ),
      )
    )
  );
}


Widget trailStopCard(final trailNumber, final trailStop, String selectedDirectory) {
  final trailStopImage = fullImage('$selectedDirectory/trails/trail$trailNumber/images/${trailStop['images'][0]}', selectedDirectory);
  final trailStopTitle = titleSmall(trailStop['name']);
  final trailStopDescription = description(trailStop['description']);

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
          trailStopImage,
          // Title
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: trailStopTitle,
          ),
          // Description
          trailStopDescription,
        ],
      ),
    )
  );
}


Widget trailStopAudioCard(final trailNumber, final trailStop, context, String selectedDirectory) {
  final trailStopImage = fullImage('$selectedDirectory/trails/trail$trailNumber/images/${trailStop['images'][0]}', selectedDirectory);
  final trailStopTitle = titleSmall(trailStop['name']);
  final trailStopAudioPath = 'trails/trail$trailNumber/audio/${trailStop['audio']}';

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
          trailStopImage,
          // Title
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: trailStopTitle,
            )
          ),
          Center(
            child: ElevatedButton(
              style: compactButton(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrailStopAudioPage(
                      trailStopImage: trailStopImage, 
                      trailStopTitle: trailStopTitle, 
                      trailStopAudioPath: trailStopAudioPath,
                      selectedDirectory: selectedDirectory,
                    ),
                  )
                );
              },
              child: const Text('Listen'),
            ),
          )
        ]
      )
    ),
  );
}


Widget viewTrailMapCard(context, String selectedDirectory) {
  final visitWebsiteTitle = titleLargeCentered("View Trail Map", Colors.white);
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrailMapPDF(selectedDirectory: selectedDirectory),
        )
      );
    },
    child: Card(
      color: pineGreen,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: visitWebsiteTitle
      ),
    )
  );
}

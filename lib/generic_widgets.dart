import 'dart:io';
import 'package:flutter/material.dart';

import 'colors.dart';


// An image sized to fill a container's width
Widget fullImage(final filepath, String selectedDirectory) {
  // From assets
  if (selectedDirectory == 'assets') {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        filepath, 
        width: double.infinity, 
        fit: BoxFit.fitWidth
      ),
    );
  }
  // From application documents
  else {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.file(
        File(filepath), 
        width: double.infinity, 
        fit: BoxFit.fitWidth
      ),
    );
  }
}


// Size 20, bold, and centered text
Widget titleLargeCentered(final text, final selectedColor) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: selectedColor),
    textAlign: TextAlign.center
  );
}


// Size 16 and bold text
Widget titleSmall(final text) {
  return Text(
    text,
    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
  );
}

// Size 16 and bold text
Widget titleSmallCentered(final text) {
  return Text(
    text,
    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    textAlign: TextAlign.center
  );
}


// Size 14 and semi-bold text
Widget subtitle(final text) {
  return Text(
    text,
    style: const TextStyle(fontWeight: FontWeight.w500)
  );
}


// Size 14 and slightly translucent text
Widget description(final text) {
  return Text(
    text,
    style: const TextStyle(color: Colors.black)
  );
}


// A divider container with size 20, bold, and centered text
Widget divider(final text, final textColor, backgroundColor) {
  return Card(
    color: backgroundColor,
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: titleLargeCentered(text, textColor)
    )
  );
}


// An app bar at the top of the screen
PreferredSizeWidget appBar(bool showLogo) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(48.0),
    child: AppBar(
      leading: showLogo ? Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
        child: Image.asset('assets/icon_white.png'),
      ) : null,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      centerTitle: true,
      shape: const Border(
        bottom: BorderSide(
          color: Colors.black,
          width: 2,
        )
      ),
      backgroundColor: pineGreen,
      title: const Text(
        'KNC Mobile',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
      )
    )
  );
}


// A small, pine green button with white text
ButtonStyle compactButton() {
  return ElevatedButton.styleFrom(
    backgroundColor: pineGreen,
    foregroundColor: Colors.white,
  );
}


// A page that's empty besides placeholder text
Widget emptyPage(final text) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        description(text)
      ]
    ),
  );
}


// A loading screen with a spinning progress indicator
Widget loadingScreen(final String text) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(
          color: pineGreen
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0)
        ),
        description(text)
      ]
    )
  );
}

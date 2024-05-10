import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


// Given a JSON file's relative path, asynchronously read and return its contents
dynamic readJSON(final filePath) async {
  try {
    final response = await File(filePath).readAsString();
    final data = await jsonDecode(response);
    return data;
  }
  catch (e) {
    return null;
  }
}


// Given a bundled JSON file's relative path, asynchronously read and return its contents
dynamic readBundledJSON(final filePath) async {
  try {
    final response = await rootBundle.loadString(filePath);
    final data = await jsonDecode(response);
    return data;
  }
  catch (e) {
    return null;
  }
}


// Given a URL, open it in the device's default web browser
Future<void> launchURL(final url) async {
   await launchUrl(url, mode: LaunchMode.externalApplication);
}


// Given a duration, format it into hours, minutes, and seconds, and return it
String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');
}

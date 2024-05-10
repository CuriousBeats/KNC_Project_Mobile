import 'package:flutter/material.dart';
import 'dart:io';

import 'help_widgets.dart';
import '../colors.dart';
import '../generic_functions.dart';
import '../generic_widgets.dart';
import '../documents_path.dart';
import '../update_from_drive.dart' as drive_interface;


class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String selectedDirectory = '';
  String filePathContacts = '';
  String filePathAddresses = '';
  List contacts = [];
  List addresses = [];
  bool loading = true;
  bool checkingForUpdates = false;

  // Select either application documents or assets
  Future<void> selectDirectory() async {
    // If the file exists in application documents, select application documents
    if (File('$documentsPath/addresses.json').existsSync() && File('$documentsPath/contacts.json').existsSync()) {
      selectedDirectory = documentsPath;
    }
    // Otherwise, select assets
    else {
      selectedDirectory = 'assets';
    }
    filePathAddresses = '$selectedDirectory/addresses.json';
    filePathContacts = '$selectedDirectory/contacts.json';
  }

  // Read contacts.json
  Future<void> readContacts() async {
    dynamic data;
    // If the application directory is in use, the JSON file isn't bundled
    if (selectedDirectory == documentsPath) {
      data = await readJSON(filePathContacts);
    }
    // Otherwise, assets is in use, and the JSON file is bundled
    else {
      data = await readBundledJSON(filePathContacts);
      try {
        contacts = data['contacts'];
      }
      catch (e) {
        contacts = [];
      }
    }
  }

  // Read addresses.json
  Future<void> readAddresses() async {
    dynamic data;
    // If the application directory is in use, the JSON file isn't bundled
    if (selectedDirectory == documentsPath) {
      data = await readJSON(filePathAddresses);
    }
    // Otherwise, assets is in use, and the JSON file is bundled
    else {
      data = await readBundledJSON(filePathAddresses);
      try {
        addresses = data['addresses'];
      }
      catch (e) {
        addresses = [];
      }
    }
  }

  Future<void> readContent() async {
    await selectDirectory();
    await readContacts();
    await readAddresses();
    setState(() {});
    loading = false;
  }

  // Check for updates
  Future<void> checkForUpdates() async {
    setState(() {
      checkingForUpdates = true;
    });
    await drive_interface.main();
    setState(() {
      checkingForUpdates = false;
    });
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
    if (contacts.isEmpty || addresses.isEmpty) {
      return Scaffold(
        appBar: appBar(true),
        body: emptyPage('No help information is currently available.')
      );
    }
    
    // If checking for updates, display a loading screen
    if (checkingForUpdates) {
      return Scaffold(
        appBar: appBar(true),
        body: loadingScreen('Fetching updates...')
      );
    }

    // Otherwise, display content
    return Scaffold(
      appBar: appBar(true), 
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length + addresses.length + 2,
              itemBuilder: (context, index) {
                if (index < contacts.length) {
                  dynamic contact = contacts[index];
                  return contactCard(contact);
                }
                else if (index < contacts.length+addresses.length) {
                  dynamic address = addresses[index-contacts.length];
                  return addressCard(address);
                }
                else if (index < contacts.length + addresses.length + 1) {
                  return visitWebsiteCard('https://naturecenter.org/', 'Visit the KNC Website', Colors.white, pineGreen);
                }
                else {
                  return InkWell(
                    onTap: () {
                      checkForUpdates();
                    },
                    child: Card(
                      color: pineGreen,
                      shadowColor: Colors.transparent,
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: titleLargeCentered('Check for Updates', Colors.white)
                      ),
                    )
                  );
                }
              },
            ),
          ),
        ],
      )
    );
  }
}

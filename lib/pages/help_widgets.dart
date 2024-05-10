import 'package:flutter/material.dart';

import '../colors.dart';
import '../generic_functions.dart';
import '../generic_widgets.dart';
import '../update_from_drive.dart' as drive_interface;


Widget contactCard(final contact) {
  final contactTitle = titleSmall(contact['name']);
  final contactSubtitle = subtitle(contact['position']);
  final contactPhone = description(contact['phone']);
  final contactEmail = description(contact['email']);

  return Card(
    color: lightBlue,
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          contactTitle,
          contactSubtitle,
          contactPhone,
          contactEmail,
        ],
      ),
    )
  );
}


Widget addressCard(final address) {
  final addressTitle = titleSmall('Mailing Address');
  final addressName = description(address['name']);
  final addressLine1 = description(address['street']);
  final addressLine2 = description(address['city'] + ' ' + address['state'] + ', ' + address['zip']);

  return Card(
    color: lightBrown,
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addressTitle,
          addressName,
          addressLine1,
          addressLine2,
        ],
      ),
    )
  );
}


Widget visitWebsiteCard(final selectedURL, final text, final textColor, final backgroundColor) {
  final visitWebsiteTitle = titleLargeCentered(text, textColor);
  
  return InkWell(
    onTap: () {
      final Uri url = Uri.parse(selectedURL);
      launchURL(url);
    },
    child: Card(
      color: backgroundColor,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: visitWebsiteTitle
      ),
    )
  );
}


Widget checkForUpdatesCard(final text, final textColor, final backgroundColor) {
  return InkWell(
    onTap: () {
      drive_interface.main();
    },
    child: Card(
      color: backgroundColor,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: titleLargeCentered(text, textColor)
      ),
    )
  );
}

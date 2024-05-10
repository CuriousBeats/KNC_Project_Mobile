import 'package:path_provider/path_provider.dart';


String documentsPath = '';

// Get the file path to the application documents directory
getDocumentsPath() async {
  final directory = await getApplicationSupportDirectory();
  documentsPath = directory.path;
}

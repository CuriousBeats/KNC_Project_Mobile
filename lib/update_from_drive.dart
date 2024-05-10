import 'dart:convert';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import 'documents_path.dart' as documents_path;


// Service Account Authentication
Future<drive.DriveApi> serviceAccountLogin(String serviceAccountFile) async {
  var scopes = [drive.DriveApi.driveScope];

  var credentials = ServiceAccountCredentials.fromJson(jsonDecode(await rootBundle.loadString(serviceAccountFile)) as Map<String, dynamic>);

  var authClient = await clientViaServiceAccount(credentials, scopes);
  return drive.DriveApi(authClient);
}

// Listing Files in a Folder
Future<List<drive.File>> listFilesInFolder(drive.DriveApi service, String folderId) async {
  var query = "'$folderId' in parents";
  var result = await service.files.list(
    q: query,
    spaces: 'drive',
    $fields: 'nextPageToken, files(id, name, mimeType, modifiedTime)',
  );
  return result.files ?? [];
}

// Comparing File Modification Times
bool isDriveFileNewer(drive.File driveFile, String localFilePath) {
  if (!File(localFilePath).existsSync()) {
    return true; 
  }

  var localModifiedTime = File(localFilePath).lastModifiedSync().toLocal();
  var driveModifiedTime = driveFile.modifiedTime?.toLocal();
  if (driveModifiedTime == null){
    return false;
  }
  return driveModifiedTime.isAfter(localModifiedTime);
}

// Downloading a File
Future downloadFile(drive.DriveApi service, String fileId, String fileSavePath, Set<String> localFilesSet) async {
  var driveFile = await service.files.get(fileId, downloadOptions: drive.DownloadOptions.metadata) as drive.File;

  if (File(fileSavePath).existsSync() && !isDriveFileNewer(driveFile, fileSavePath)){
    localFilesSet.remove(fileSavePath);
    return;
  } else {
    var media = await service.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
   
    var byteData = await media.stream.toList().then((listOfChunks) {
      return listOfChunks.expand((chunk) => chunk).toList();
    });
    await File(fileSavePath).writeAsBytes(byteData);
    localFilesSet.remove(fileSavePath);
  }
}

// Handling Local Files Not on Drive
void deleteLocalFilesNotOnDrive(Set<String> localFiles) {
  for (var filePath in localFiles) {
    if (FileSystemEntity.isDirectorySync(filePath)) {
      Directory(filePath).deleteSync(recursive: true);
    } else if (FileSystemEntity.isFileSync(filePath)){
      File(filePath).deleteSync();
    }
  }
}

// Getting all local files 
Set<String> getLocalFiles(String localDownloadPath) {
  var localFiles = <String>{};
  for (var entity in Directory(localDownloadPath).listSync(recursive: true)) {
    localFiles.add(entity.path);
  }
  return localFiles;
}

// Main function
main() async {
  var folderId = '1BbceTU8BJY8fnsYelKtRuIxk3RBeBW80'; // ID of the folder to download
  var localDownloadPath = documents_path.documentsPath;

  var service = await serviceAccountLogin('assets/serviceAccnt_secret.json');
  var localFiles = getLocalFiles(localDownloadPath);
  localFiles = await downloadFolder(service, folderId, localDownloadPath, localFiles);
  deleteLocalFilesNotOnDrive(localFiles);
}

// Recursive Folder Download Function
Future downloadFolder(drive.DriveApi service, String folderId, String localPath, Set<String> localFilesSet) async {
  if (!Directory(localPath).existsSync()) {
    Directory(localPath).createSync();
  }

  var items = await listFilesInFolder(service, folderId);
  for (var item in items) {
    if (item.mimeType != 'application/vnd.google-apps.folder') {
      var fileSavePath = path.join(localPath, item.name!);
      await downloadFile(service, item.id!, fileSavePath, localFilesSet);
      // remove the file from the local files set if it exists
      if(localFilesSet.contains(fileSavePath)){
        localFilesSet.remove(fileSavePath);
      }
    } else { 
      var newLocalPath = path.join(localPath, item.name!);
      if(localFilesSet.contains(newLocalPath)){
        localFilesSet.remove(newLocalPath);
      }
      localFilesSet = await downloadFolder(service, item.id!, newLocalPath, localFilesSet);
    }
  }
  return localFilesSet;
}

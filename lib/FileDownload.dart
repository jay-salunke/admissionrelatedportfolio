import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FileDownload {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  getFileNames() async {
    final getFilesData = (await FirebaseStorage.instance.ref().listAll()).items;
    print(getFilesData);
    return getFilesData;
  }

  Future<bool> getLocalStorageFiles(List<File> selectedFiles) async {
    bool _isResult = false;
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        selectedFiles.clear();
        result.files.forEach((selectedFile) {
          File file = new File(selectedFile.path.toString());
          selectedFiles.add(file);
          selectedFiles.forEach((file) {
            uploadFileToStorage(file);
          });
        });
        _isResult = true;
      }
    } catch (e) {
      print(e);
    }
    return _isResult;
  }

  uploadFileToStorage(File file) {
    firebaseStorage.ref(basename(file.path)).putFile(file);
  }

  void downloadFile(List<Reference> filteredFiles, int index) async {
    Reference ref = filteredFiles[index];
    String fileName = basenameWithoutExtension(filteredFiles[index].name);
    File filePath =
        new File('storage/emulated/0/Download/${filteredFiles[index].name}');
    if (await filePath.exists()) {
      int counter = 1;
      String newFile = "";
      while (await filePath.exists()) {
        newFile = fileName + " ($counter)";
        filePath = File(
            'storage/emulated/0/Download/${filteredFiles[index].name.replaceAll(fileName, newFile)}');
        ++counter;
      }
      try {
        ref.writeToFile(filePath);
      } on FirebaseException catch (e) {
        print(e.message.toString());
      }
    } else {
      try {
        ref.writeToFile(filePath);
      } on FirebaseException catch (ex) {
        print(ex.message.toString());
      }
    }
  }
}

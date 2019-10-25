import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class FileStorage {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await localPath;
    final file = File('$path/image.png');
    print(file);
    return file;
  }

  Future<File> writeCounter(List<int> html) async {
    final file = await _localFile;
    print(file);
    // Write the file
    return await file.writeAsBytes(html);
  }

  Future<File> downloadPDFFile(String url, String filename) async {
    http.Client _client = new http.Client();
    var req = await _client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
    print(file);
    
  }
  Future<File> get _localPDFFile async {
    final path = await localPath;
    final file = File('$path/pdfFile.pdf');
    print(file);
    return file;
  }
   Future<File> writePDFCounter(List<int> html) async {
    final file = await _localPDFFile;
    print(file);
    // Write the file
    return await file.writeAsBytes(html);
  }


}
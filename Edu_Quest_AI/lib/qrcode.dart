import 'package:flutter/material.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class QRCodeScannerPage extends StatelessWidget {
  const QRCodeScannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: QRCodeDartScanView(
        scanInvertedQRCode: true, // Enable inverted QR code scanning
        typeScan: TypeScan.live, // Scan mode: live scanning
        onCapture: (Result result) {
          // Handle the result of the scan
          if (result.text.isNotEmpty) {
            // Close the scanner page and return the result to the previous screen
            Navigator.of(context).pop(result.text);
          }
        },
      ),
    );
  }
}

Future<String> sendQRToBackend(String url) async {
  try {
    // Make the HTTP request
    List<String> parts = url.split(':');
    url=parts.first+"s"+":"+parts.last;
    print(url);
    final response = await http.get(Uri.parse(url));

    // Print the status code
    print('Status code: ${response.statusCode}');

    // Check for successful response
    if (response.statusCode == 200) {
      // Print the contents of the page
      final responseBody = response.body;
      print('Response body: $responseBody');

      // Parse the HTML to extract the PDF link
      final document = htmlParser.parse(responseBody);

      // Target the <a> tag inside the <ul> with class "list list-unstyled"
      final linkElement = document.querySelector('ul.list-unstyled > li > a');
      final linkHref = linkElement?.attributes['href'] ?? 'No PDF link found';
      if (linkHref != 'No PDF link found') {
        List<String> parts = linkHref.split('/');
        // Step 4: Download the PDF and save it to the specified storage path
        String downloadResult = await downloadFile(linkHref, parts.last);
        return downloadResult;
      } else {
        return 'No PDF link found';
      }
    } else {
      return 'Failed to load page';
    }
  } catch (e) {
    // Handle other errors
    print('Error: $e');
    return 'Error occurred';
  }
}

Future<String> downloadFile(String url, String filename) async {
  // Step 1: Check and request permission
  if (Platform.isAndroid) {
    await Permission.manageExternalStorage.request();
  } else {
    await Permission.storage.request();
  }

  if (true) {
    try {
      // Step 2: Get the directory for saving the file
      Directory? directory = await getExternalStorageDirectory();
      String newPath = "";
      List<String> paths = directory!.path.split("/");
      print(paths);
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/FilesDownload";  // Define your custom folder here
      directory = Directory(newPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);  // Create the directory if it doesn't exist
      }

      String filePath = "${directory.path}/$filename";  // Define the file path with the given filename

      // Step 3: Download the file using Dio
      Dio dio = Dio();
      await dio.download(url, filePath);
      return '$filePath';
    } catch (e) {
      print(e);
      return 'Error occurred during download: $e';
    }
  } else {
    return 'Storage permission not granted';
  }
}
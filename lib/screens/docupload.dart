import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import './pdf_screen.dart';

class DocUploader extends StatefulWidget {
  @override
  _DocUploaderState createState() => _DocUploaderState();
}

class _DocUploaderState extends State<DocUploader> {
  String text = 'No File Chosen';
  String pathPDF = "";
  List<Uint8List> picturesBytes = [];
  Future<void> _pickFile() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      print("Has pictures");

      result.files.forEach((f) {
        picturesBytes.add(f.bytes);
      });

      print(picturesBytes);
      print(result.files.length);
    } else {
      print("Null or doesn't have pictures");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Pdf Uploader and Viewer',
            style: GoogleFonts.roboto(color: Colors.white)),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(color: Colors.black)),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
                color: Colors.blue,
                child: Text(
                  'Pick File',
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
                onPressed: _pickFile),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text(
                'View File',
                style: GoogleFonts.roboto(color: Colors.white),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PdfScreen(pathPDF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

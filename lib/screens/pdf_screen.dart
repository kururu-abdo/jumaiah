import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreen extends StatelessWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final String pathPDF;
  PdfScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        body: SfPdfViewer.asset(pathPDF));
  }
}

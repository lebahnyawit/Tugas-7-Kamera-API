import 'dart:io';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final String imagePath;

  // Constructor wajib untuk menerima alamat foto dari layar sebelumnya
  const PreviewScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Image.file(File(widget.imagePath), fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}

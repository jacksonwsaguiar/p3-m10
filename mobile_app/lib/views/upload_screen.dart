import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/Image_controller.dart';
import 'package:mobile_app/services/image_service.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? image;
  final String imageWithFilter = "";

  final imgController = ImageController();
  final service = ImageService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Filter app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                final file = await imgController.getImage();

                setState(() {
                  image = file;
                });
              },
              child: const Text("Upload image")),
          if (image != null)
            ElevatedButton(
                onPressed: () async {
                  await service.uploadImage(image!);
                },
                child: const Text("Processar")),
          if (imageWithFilter.isNotEmpty)
            ElevatedButton(
                onPressed: () {
                  _showImageAlertDialog(context, imageWithFilter);
                },
                child: const Text("Ver imagem processada"))
        ],
      ),
    ));
  }

  void _showImageAlertDialog(BuildContext context, String src) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image em preto e branco'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                'http://localhost:80/processed/$src',
                width: 200,
              ),
              const SizedBox(height: 16), // Adjust spacing as needed
              const Text('This is your image description.'),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}

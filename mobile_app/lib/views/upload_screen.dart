import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
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
  dynamic imageWithFilter = "";

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(),
          if (image != null)
            Image.file(
              image!,
              width: 300,
              height: 300,
            )
          else
            Icon(Icons.image_not_supported_sharp),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                final file = await imgController.getImage();

                setState(() {
                  image = file;
                });
              },
              child: const Text("Upload image")),
          const SizedBox(height: 20),
          if (image != null)
            ElevatedButton(
                onPressed: () async {
                  var res = await service.uploadImage(image!);

                  await AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: -1,
                          channelKey: "alerts",
                          title: 'Imagem processada',
                          body:
                              "Imagem convertida para preto e branco com sucesso!"));

                  setState(() {
                    imageWithFilter = res;
                  });
                },
                child: const Text("Processar")),
          const SizedBox(height: 20),
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

  void _showImageAlertDialog(BuildContext context, Uint8List src) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image em preto e branco'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.memory(
                src,
                width: 200,
              ),
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

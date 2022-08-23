import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({required this.onImageSelected});

  final Function(File) onImageSelected;

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomSheet(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          backgroundColor: Colors.white,
          onClosing: () {},
          builder: (_) =>
              Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await picker.pickImage(source: ImageSource.camera);
                      onImageSelected(File(pickedFile!.path));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[300],
                      onSurface: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: Text(
                      'Câmera',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      onImageSelected(File(pickedFile!.path));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[300],
                      onSurface: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: Text(
                      'Galeria',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
                    )),
              ]));
    } else {
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para o item', style: TextStyle(fontSize: 18)),
        message: const Text('Escolha a origem da foto', style: TextStyle(fontSize: 16)),
        cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20))),
        actions: [
          CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.camera);
                onImageSelected(File(pickedFile!.path));
              },
              child: Text('Câmera', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20))),
          CupertinoActionSheetAction(
              onPressed: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                onImageSelected(File(pickedFile!.path));
              },
              child: Text('Galeria', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20)))
        ],
      );
    }
  }
}

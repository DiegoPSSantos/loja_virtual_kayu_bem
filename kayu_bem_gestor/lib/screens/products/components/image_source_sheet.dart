import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({required this.onImageSelected});

  final Function(File) onImageSelected;

  final ImagePicker picker = ImagePicker();

  Future<void> imageEdit(String path, BuildContext context) async {
    final File? imageCropped = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: StringHelper.TITULO_EDIT_IMAGE.toUpperCase(),
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white),
        iosUiSettings: const IOSUiSettings(
            title: StringHelper.TITULO_EDIT_IMAGE_UPPER,
            cancelButtonTitle: StringHelper.LABEL_CANCELAR,
            doneButtonTitle: StringHelper.LABEL_CONCLUIR));
    if (imageCropped != null) {
      onImageSelected(imageCropped);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomSheet(
          onClosing: () {},
          builder: (_) =>
              Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await picker.pickImage(source: ImageSource.camera);
                      imageEdit(pickedFile!.path, context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onSurface: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: Text(
                      StringHelper.LABEL_CAMERA,
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      imageEdit(pickedFile!.path, context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onSurface: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: Text(
                      StringHelper.LABEL_GALERIA,
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
                    )),
              ]));
    } else {
      return CupertinoActionSheet(
        title: const Text(StringHelper.MSG_SELECT_PHOTO, style: TextStyle(fontSize: 18)),
        message: const Text(StringHelper.MSG_SELECT_ORIGIN_PHOTO, style: TextStyle(fontSize: 16)),
        cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(StringHelper.LABEL_CANCELAR,
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20))),
        actions: [
          CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.camera);
                imageEdit(pickedFile!.path, context);
              },
              child: Text(StringHelper.LABEL_CAMERA,
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20))),
          CupertinoActionSheetAction(
              onPressed: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                imageEdit(pickedFile!.path, context);
              },
              child: Text(StringHelper.LABEL_GALERIA,
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20)))
        ],
      );
    }
  }
}

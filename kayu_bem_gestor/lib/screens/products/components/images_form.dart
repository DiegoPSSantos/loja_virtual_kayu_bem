import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:kayu_bem_gestor/helpers/image_helper.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';
import 'package:kayu_bem_gestor/models/product.dart';

import 'image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  const ImagesForm(this.produto);

  final Product produto;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return FormField<List<dynamic>>(
        initialValue: produto.imagens,
        validator: (images) {
          if (images!.isEmpty) {
            return StringHelper.ERROR_MSG_001;
          }
          return null;
        },
        onSaved: (images) => produto.novasImagens = images,
        builder: (state) {
          void onImageSelected(File file) {
            state.value!.add(file);
            state.didChange(state.value);
            Navigator.of(context).pop();
          }

          return Column(
            children: [
              AspectRatio(
                  aspectRatio: 1,
                  child: CarouselSlider(
                    slideTransform: const CubeTransform(),
                    slideIndicator: CircularSlideIndicator(
                      currentIndicatorColor: Colors.white,
                      indicatorBackgroundColor: primaryColor,
                      padding: const EdgeInsets.only(bottom: 32),
                      indicatorBorderColor: primaryColor,
                    ),
                    children: state.value!
                        .map<Widget>((img) => Stack(
                              fit: StackFit.expand,
                              children: [
                                if (img is ImageHelper)
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          image: DecorationImage(image: NetworkImage(img.url!), fit: BoxFit.cover)))
                                else
                                  Image.file(
                                    img as File,
                                    fit: BoxFit.fill,
                                  ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5))),
                                        child: IconButton(
                                            icon: const Icon(Icons.delete_forever_rounded, size: 32),
                                            color: Colors.redAccent,
                                            splashColor: Colors.grey,
                                            onPressed: () {
                                              state.value!.remove(img);
                                              state.didChange(state.value);
                                            }))),
                              ],
                            ))
                        .toList()
                      ..add(Material(
                          color: Colors.grey[100],
                          child: IconButton(
                              icon: Icon(Icons.add_a_photo, size: 50, color: primaryColor),
                              onPressed: () {
                                if (Platform.isAndroid) {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (_) => ImageSourceSheet(onImageSelected: onImageSelected));
                                } else {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (_) => ImageSourceSheet(onImageSelected: onImageSelected));
                                }
                              }))),
                  )),
              if (state.hasError)
                Container(
                    margin: const EdgeInsets.only(top: 16, left: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(state.errorText!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)))
            ],
          );
        });
  }
}

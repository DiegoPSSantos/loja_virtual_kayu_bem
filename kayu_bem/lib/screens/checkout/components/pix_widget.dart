import 'dart:io';

import 'package:custom_clippers/Clippers/multiple_points_clipper.dart';
import 'package:custom_clippers/enum/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kayu_bem/helpers/image_source_sheet.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:kayu_bem/models/checkout_manager.dart';
import 'package:kayu_bem/models/user_manager.dart';
import 'package:provider/src/provider.dart';
import 'package:share/share.dart';

class PixWidget extends StatefulWidget {
  @override
  State<PixWidget> createState() => _PixWidgetState();
}

class _PixWidgetState extends State<PixWidget> {
  File? comprovante;

  CheckoutManager? checkoutManager;

  @override
  void initState() {
    checkoutManager = context.read<CheckoutManager>();
    final usuarioManager = context.read<UserManager>();
    final cartManager = context.read<CartManager>();
    checkoutManager!.gerarQRCode(produtos: cartManager.items, usuario: usuarioManager.usuario!);
  }

  @override
  Widget build(BuildContext context) {

    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Image.asset(StringHelper.PIX_LOGO, height: 35),
              const SizedBox(height: 10),
              Stack(
                children: [
                  //Image.asset(StringHelper.PIX_CONTA),
                  Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: StringHelper.COPIA_QRCODE,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Share.share(StringHelper.CODIGO_QRCODE);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(top: 250),
                              color: Colors.transparent,
                              height: 45,
                              width: 265)))
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      void onImageSelected(File file) {
                        setState(() {
                          comprovante = file;
                          checkoutManager!.comprovante = file;
                        });
                        Navigator.of(context).pop();
                      }

                      if (Platform.isAndroid) {
                        showModalBottomSheet(
                            context: context, builder: (_) => ImageSourceSheet(onImageSelected: onImageSelected));
                      } else {
                        showCupertinoModalPopup(
                            context: context, builder: (_) => ImageSourceSheet(onImageSelected: onImageSelected));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        onSurface: Theme.of(context).primaryColor.withAlpha(100),
                        onPrimary: Colors.white,
                        primary: Theme.of(context).primaryColor),
                    child: Text(StringHelper.BTN_ANEXO_COMPROVANTE.toUpperCase())),
              ),
              if (comprovante != null)
                ClipPath(
                    clipper: MultiplePointsClipper(Sides.VERTICAL, heightOfPoint: 15, numberOfPoints: 8),
                    child: Container(
                      color: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
                        child: Image.file(
                      comprovante!,
                      fit: BoxFit.fill,
                    )))
            ])));
  }
}

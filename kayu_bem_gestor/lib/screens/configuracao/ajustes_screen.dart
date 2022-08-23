import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kayu_bem_gestor/common/rounded_custom_button.dart';
import 'package:kayu_bem_gestor/helpers/loading_helper.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';
import 'package:kayu_bem_gestor/models/configuracao_manager.dart';
import 'package:provider/provider.dart';

class AjustesScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AJUSTES'),
        centerTitle: true,
        leading: InkWell(onTap: () => ZoomDrawer.of(context)!.toggle(), child: const Icon(Icons.menu)),
      ),
      body: Consumer<ConfiguracaoManager>(builder: (context, configuracaoManager, __) {
        if (configuracaoManager.success) {
          Fluttertoast.showToast(
              msg: StringHelper.MSG_AJUSTES_ATUALIZADOS,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        if (configuracaoManager.loading) {
          return LoadingHelper();
        }
        return Form(
            key: formKey,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text('Valor base para calculo do frete',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      TextFormField(
                        initialValue: configuracaoManager.configuracao!.base.toString(),
                        decoration: const InputDecoration(hintText: '0', isDense: true),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (base) {
                          if (base!.isEmpty) {
                            return 'Informe um valor base para o cálculo do frete';
                          } else {
                            return null;
                          }
                        },
                        onSaved: configuracaoManager.setBase,
                      ),
                      const SizedBox(height: 8),
                      const Text('Latitude', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      TextFormField(
                        initialValue: configuracaoManager.configuracao!.lat.toString(),
                        decoration: const InputDecoration(hintText: '0', isDense: true),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (lat) {
                          if (lat!.isEmpty) {
                            return 'Informe o valor da latitude';
                          } else {
                            return null;
                          }
                        },
                        onSaved: configuracaoManager.setLat,
                      ),
                      const SizedBox(height: 8),
                      const Text('Longitude', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      TextFormField(
                        initialValue: configuracaoManager.configuracao!.long.toString(),
                        decoration: const InputDecoration(hintText: '0', isDense: true),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (long) {
                          if (long!.isEmpty) {
                            return 'Informe o valor da longitude';
                          } else {
                            return null;
                          }
                        },
                        onSaved: configuracaoManager.setLong,
                      ),
                      const SizedBox(height: 8),
                      const Text('Raio de entrega', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      TextFormField(
                        initialValue: configuracaoManager.configuracao!.maxkm.toString(),
                        decoration: const InputDecoration(hintText: '0', isDense: true),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (raio) {
                          if (raio!.isEmpty) {
                            return 'Informe o valor máximo em KM para o raio de entrega';
                          } else {
                            return null;
                          }
                        },
                        onSaved: configuracaoManager.setRaio,
                      ),
                      const SizedBox(height: 8),
                      const Text('Preço/KM', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      TextFormField(
                        initialValue: configuracaoManager.configuracao!.precokm.toString(),
                        decoration: const InputDecoration(hintText: '0', isDense: true),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (precokm) {
                          if (precokm!.isEmpty) {
                            return 'Informe o preço por km rodado';
                          } else {
                            return null;
                          }
                        },
                        onSaved: configuracaoManager.setPrecoKM,
                      ),
                      const SizedBox(height: 16),
                      RoundedCustomButton(
                          onPressed: configuracaoManager.saveData, loading: false, titulo: 'SALVAR', formKey: formKey)
                    ],
                  )),
            ));
      }),
    );
  }
}

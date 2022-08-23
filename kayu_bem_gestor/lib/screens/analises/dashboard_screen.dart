import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem_gestor/screens/analises/components/grafico_barra_horizontal.dart';
import 'package:kayu_bem_gestor/screens/analises/components/mapa_vendas.dart';

import 'components/grafico_barra_vertical.dart';
import 'components/grafico_pizza.dart';
import 'components/grafico_rosca.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Widget> graficos = [];
  List<Widget> graficosMinimizados = [];

  @override
  void initState() {
    super.initState();
    inicializarListaGraficos();
  }

  void inicializarListaGraficos() {
    graficosMinimizados = [
      Expanded(child: GraficoBarraHorizontal()),
      Expanded(child: GraficoBarraVertical()),
      Expanded(child: GraficoRosca())
    ];
    graficos = [
      MapaVendas(),
      GraficoPizza(),
      Row(children: graficosMinimizados)
    ];
  }

  Widget _getItemGrafico(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            if (index != 1) {
              var temp = graficos[1];
              graficos[1] = graficosMinimizados[index];
              graficosMinimizados[index] = temp;
            }
          });
        },
        child: graficos[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PAINÉIS'),
          centerTitle: true,
          leading: InkWell(onTap: () => ZoomDrawer.of(context)!.toggle(), child: const Icon(Icons.menu)),
        ),
        body: ListView.builder(
            itemCount: graficos.length, itemBuilder: _getItemGrafico, padding: const EdgeInsets.all(4)));
  }
}

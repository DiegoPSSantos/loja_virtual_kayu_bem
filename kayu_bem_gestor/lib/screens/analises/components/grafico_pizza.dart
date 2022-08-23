import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/models/dashboard_manager.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'dados.dart';

class GraficoPizza extends StatefulWidget {
  @override
  _GraficoPizzaState createState() => _GraficoPizzaState();
}

class _GraficoPizzaState extends State<GraficoPizza> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(child: Consumer<DashboardManager>(builder: (_, dashManager, __) {
      List<Dados> dados = carregarDadosGrafico(dashManager.categorias, dashManager.total);
      return SafeArea(
          child: SfCircularChart(
              title: ChartTitle(text: 'Total de vendas por categoria'),
              legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
              tooltipBehavior: _tooltipBehavior,
              series: <CircularSeries>[
            PieSeries<Dados, String>(
                dataSource: dados,
                xValueMapper: (Dados d, _) => d.categoria,
                yValueMapper: (Dados d, _) => d.quantidade,
                dataLabelSettings:
                    const DataLabelSettings(isVisible: true, textStyle: TextStyle(fontWeight: FontWeight.w800)),
                dataLabelMapper: (Dados d, _) => '${d.percentual}%',
                enableTooltip: true)
          ]));
    }));
  }

  List<Dados> carregarDadosGrafico(Map<String, int> dados, int total) {
    final List<Dados> lista = [];
    dados.forEach((categoria, quantidade) {
      lista.add(Dados(categoria: categoria, quantidade: quantidade, percentual: (quantidade / total) * 100));
    });
    return lista;
  }
}

import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/models/dashboard_manager.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'dados.dart';

class GraficoRosca extends StatefulWidget {
  const GraficoRosca({Key? key}) : super(key: key);

  @override
  State<GraficoRosca> createState() => _GraficoRoscaState();
}

class _GraficoRoscaState extends State<GraficoRosca> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(color: Colors.grey.withAlpha(220), child: Consumer<DashboardManager>(builder: (_, dashManager, __) {
      List<Dados> dados = carregarDadosGrafico(dashManager.categorias, dashManager.total);
      return Container(
        height: 150,
          child: SfCircularChart(
              // title: ChartTitle(text: 'Total de vendas por categoria'),
              legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, height: '200'),
              tooltipBehavior: _tooltipBehavior,
              series: <CircularSeries>[
                DoughnutSeries<Dados, String>(
                    dataSource: dados,
                    xValueMapper: (Dados d, _) => d.categoria,
                    yValueMapper: (Dados d, _) => d.quantidade,
                    dataLabelSettings:
                    const DataLabelSettings(isVisible: true, textStyle: TextStyle(fontWeight: FontWeight.w800)),
                    dataLabelMapper: (Dados d, _) => '${d.percentual}%',
                    enableTooltip: true,
                    explode: true,
                    explodeIndex: 1
                )
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

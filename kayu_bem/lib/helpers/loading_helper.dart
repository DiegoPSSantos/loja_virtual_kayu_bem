import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingHelper extends StatelessWidget {
  LoadingHelper({this.texto});

  String? texto;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey.withOpacity(0.8),
        alignment: Alignment.center,
        child: Column(children: [
          const Padding(
              padding: EdgeInsets.all(150),
              child: LoadingIndicator(
                indicatorType: Indicator.circleStrokeSpin,
                colors: [Colors.white],
                backgroundColor: Colors.transparent,
                pathBackgroundColor: Colors.transparent,
              )),
          if (texto != null)
            Text(texto!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18))
        ]));
  }
}

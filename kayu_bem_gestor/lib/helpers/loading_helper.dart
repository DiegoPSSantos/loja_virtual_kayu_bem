import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingHelper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(150),
        color: Colors.grey.withOpacity(0.8),
        alignment: Alignment.center,
        child: const LoadingIndicator(
          indicatorType: Indicator.circleStrokeSpin,
          colors: [Colors.white],
          backgroundColor: Colors.transparent,
          pathBackgroundColor: Colors.transparent,
        ));
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kayu_bem_gestor/models/dashboard_manager.dart';
import 'package:provider/provider.dart';

class MapaVendas extends StatefulWidget {
  const MapaVendas({Key? key}) : super(key: key);

  @override
  State<MapaVendas> createState() => _MapaVendasState();
}

class _MapaVendasState extends State<MapaVendas> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
  }

  CameraPosition carrregarPosicaoInicial(num lat, num lng) {
    return CameraPosition(target: LatLng(lat.toDouble(), lng.toDouble()), zoom: 3.5);
  }

  void _onAlterarTipoMapa() {
    setState(() => _currentMapType = _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal);
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    return Card(
        child: Container(
            height: 360,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Consumer<DashboardManager>(
                builder: (_, dashManager, __) =>
                    Stack(children: [
                      GestureDetector(
                          onVerticalDragStart: (start) {},
                          child: GoogleMap(
                              zoomControlsEnabled: false,
                              mapType: _currentMapType,
                              gestureRecognizers: Set()
                                ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))..add(
                                    Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
                              initialCameraPosition:
                              carrregarPosicaoInicial(dashManager.latitude, dashManager.longitude),
                              onMapCreated: (GoogleMapController controller) => _controller.complete(controller))),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(alignment: Alignment.topRight, child: Column(children: [
                            FloatingActionButton.small(onPressed: _onAlterarTipoMapa,
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(Icons.map, size: 24))
                          ]))
                      )
                    ]))));
  }
}

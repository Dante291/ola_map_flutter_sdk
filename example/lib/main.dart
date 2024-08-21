import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ola_map_flutter/ola_map_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Completer<OlaMapController> _controller = Completer<OlaMapController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: OlaMap(
              showCurrentLocation: false,
              showZoomControls: true,
              showMyLocationButton: true,
              apiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
              onPlatformViewCreated: (OlaMapController controller) {
                _controller.complete(controller);
              })),
    );
  }
}

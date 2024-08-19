import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ola_map_flutter/ola_map_flutter.dart';
import 'package:ola_map_flutter/utils/permission_location.dart';
import 'package:ola_map_flutter_example/components/zoom_button.dart';
import 'package:ola_map_flutter_example/controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _olaMapFlutterPlugin = OlaMapFlutter();
  final Completer<MyOlaMapController> _mapControllerCompleter = Completer();

  int idMap = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     final MyOlaMapController controller = await _mapControllerCompleter.future;

          //     controller.removeMarker(
          //       markerId: '1',
          //     );
          //     // controller.addCustomMarker(
          //     //   latitude: 21.028511,
          //     //   longitude: 105.804817,
          //     //   markerId: '1',
          //     //   child: Container(
          //     //     padding: EdgeInsets.all(8.0),
          //     //     color: Colors.blue,
          //     //     child: Text('Custom Marker', style: TextStyle(color: Colors.white)),
          //     //   ),
          //     // );
          //   },
          // ),
          body: Stack(
        children: [
          AndroidView(
            viewType: 'OlaMapView',
            creationParams: const {'apiKey': "4moGUXCK31I0On7PLAOAlX7RhdTPKig9IrsRvE36"},
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (int id) async {
              _mapControllerCompleter.complete(MyOlaMapController(id));
            },
          ),

          // zoom in button
          Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                children: [
                  // aare chota chota google map me jo hota ha in out wais achhaiye
                  ZoomButton(
                    onTap: () async {
                      final MyOlaMapController controller = await _mapControllerCompleter.future;
                      controller.zoomIn();
                    },
                    icon: Icons.add,
                  ),
                  const SizedBox(height: 10),
                  ZoomButton(
                    onTap: () async {
                      final MyOlaMapController controller = await _mapControllerCompleter.future;
                      controller.zoomOut();
                    },
                    icon: Icons.remove,
                  ),
                  const SizedBox(height: 10),

                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.my_location),
                      onPressed: () async {
                        final MyOlaMapController controller = await _mapControllerCompleter.future;
                        controller.moveToCurrentLocation();
                      },
                    ),
                  )
                ],
              )),
        ],
      )),
    );
  }
}

// import 'package:flutter/services.dart';

// class OlaMapView {
//   final int id;
//   final MethodChannel _channel;

//   OlaMapView(this.id) : _channel = MethodChannel('ola_map_flutter_$id');

//   Future<void> initializeMap(String apiKey) async {
//     try {
//       await _channel.invokeMethod('initializeMap', {'apiKey': apiKey});
//     } on PlatformException catch (e) {
//       throw Exception("Failed to initialize map: '${e.message}'");
//     }
//   }

//   Future<void> addMarker(double latitude, double longitude) async {
//     try {
//       await _channel.invokeMethod('addMarker', {'latitude': latitude, 'longitude': longitude});
//     } on PlatformException catch (e) {
//       throw Exception("Failed to add marker: '${e.message}'.");
//     }
//   }

//   Future<void> clearMarkers() async {
//     try {
//       await _channel.invokeMethod('clearMarkers');
//     } on PlatformException catch (e) {
//       throw Exception("Failed to clear markers: '${e.message}'.");
//     }
//   }

//   // get cuurent location
//   Future<void> getCurrentLocation() async {
//     try {
//       await checkLocationPermission();
//       await _channel.invokeMethod('getCurrentLocation');
//     } on PlatformException catch (e) {
//       throw Exception("Failed to get current location: '${e.message}'.");
//     }
//   }

//   //showCurrentLocation
//   Future<void> showCurrentLocation() async {
//     try {
//       await checkLocationPermission();
//       await _channel.invokeMethod('showCurrentLocation');
//     } on PlatformException catch (e) {
//       throw Exception("Failed to show current location: '${e.message}'.");
//     }
//   }

//   //hideCurrentLocation
//   Future<void> hideCurrentLocation() async {
//     try {
//       await _channel.invokeMethod('hideCurrentLocation');
//     } on PlatformException catch (e) {
//       throw Exception("Failed to hide current location: '${e.message}'.");
//     }
//   }
// }

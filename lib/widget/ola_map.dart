import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ola_map_flutter/ola_map_flutter.dart';
import 'package:ola_map_flutter/widget/zoom_button.dart';

class OlaMap extends StatefulWidget {
  final String apiKey;
  final bool? showCurrentLocation;
  final bool? showZoomControls;
  final bool? showMyLocationButton;
  final void Function(OlaMapController) onPlatformViewCreated;

  const OlaMap({
    Key? key,
    required this.apiKey,
    required this.onPlatformViewCreated,
    this.showCurrentLocation,
    this.showZoomControls,
    this.showMyLocationButton,
  }) : super(key: key);

  @override
  State<OlaMap> createState() => _OlaMapState();
}

class _OlaMapState extends State<OlaMap> {
  final Completer<OlaMapController> _mapControllerCompleter = Completer();

  Future<void> _handleMapController() async {
    try {
      final OlaMapController controller = await _mapControllerCompleter.future;
      if (widget.showCurrentLocation == true) {
        await controller.showCurrentLocation();
        await controller.moveToCurrentLocation();
      }
    } catch (e) {
      print('Error showing current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AndroidView(
          viewType: 'OlaMapView',
          creationParams: {'apiKey': widget.apiKey},
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (int id) {
            final OlaMapController controller = OlaMapController(id);
            _mapControllerCompleter.complete(controller);
            widget.onPlatformViewCreated(controller);
            _handleMapController(); // Handle current location
          },
        ),
        // Zoom controls and location button
        widget.showZoomControls ?? false
            ? Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  children: [
                    ZoomButton(
                      onTap: () async {
                        try {
                          final OlaMapController controller =
                              await _mapControllerCompleter.future;
                          controller.zoomIn();
                        } catch (e) {
                          print('Error zooming in: $e');
                        }
                      },
                      icon: Icons.add,
                    ),
                    const SizedBox(height: 10),
                    ZoomButton(
                      onTap: () async {
                        try {
                          final OlaMapController controller =
                              await _mapControllerCompleter.future;
                          controller.zoomOut();
                        } catch (e) {
                          print('Error zooming out: $e');
                        }
                      },
                      icon: Icons.remove,
                    ),
                    widget.showMyLocationButton ?? false
                        ? Column(
                            children: [
                              const SizedBox(height: 10),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(Icons.my_location),
                                  onPressed: () async {
                                    try {
                                      final OlaMapController controller =
                                          await _mapControllerCompleter.future;
                                      controller.moveToCurrentLocation();
                                    } catch (e) {
                                      print(
                                          'Error moving to current location: $e');
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}

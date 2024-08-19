// Custom Controller Class
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:ola_map_flutter/utils/permission_location.dart';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';
import 'dart:ui' as ui;

class MyOlaMapController {
  final int id;
  final MethodChannel _channel;

  MyOlaMapController(this.id) : _channel = MethodChannel('ola_map_flutter_$id') {
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<void> initializeMap(String apiKey) async {
    try {
      await _channel.invokeMethod('initializeMap', {'apiKey': apiKey});
    } on PlatformException catch (e) {
      throw Exception("Failed to initialize map: '${e.message}'");
    }
  }

  Future<void> addMarker(double latitude, double longitude) async {
    try {
      await _channel.invokeMethod('addMarker', {'latitude': latitude, 'longitude': longitude});
    } on PlatformException catch (e) {
      throw Exception("Failed to add marker: '${e.message}'.");
    }
  }

  Future<void> clearMarkers() async {
    try {
      await _channel.invokeMethod('clearMarkers');
    } on PlatformException catch (e) {
      throw Exception("Failed to clear markers: '${e.message}'.");
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      await checkLocationPermission();
      await _channel.invokeMethod('getCurrentLocation');
    } on PlatformException catch (e) {
      throw Exception("Failed to get current location: '${e.message}'.");
    }
  }

  Future<void> showCurrentLocation() async {
    try {
      await checkLocationPermission();
      await _channel.invokeMethod('showCurrentLocation');
    } on PlatformException catch (e) {
      throw Exception("Failed to show current location: '${e.message}'.");
    }
  }

  Future<void> hideCurrentLocation() async {
    try {
      await _channel.invokeMethod('hideCurrentLocation');
    } on PlatformException catch (e) {
      throw Exception("Failed to hide current location: '${e.message}'.");
    }
  }

  // zoomin
  Future<void> zoomIn() async {
    try {
      await _channel.invokeMethod('zoomIn');
    } on PlatformException catch (e) {
      throw Exception("Failed to zoom in: '${e.message}'.");
    }
  }

  // zoomout
  Future<void> zoomOut() async {
    try {
      await _channel.invokeMethod('zoomOut');
    } on PlatformException catch (e) {
      throw Exception("Failed to zoom out: '${e.message}'.");
    }
  }

//zoom
  Future<void> zoomTo({required double zoom}) async {
    try {
      await _channel.invokeMethod('zoomTo', {'value': zoom});
    } on PlatformException catch (e) {
      throw Exception("Failed to zoom to: '${e.message}'.");
    }
  }

  //current location
  Future<void> moveToCurrentLocation() async {
    try {
      var currentlocation = await checkLocationPermission();

      if (currentlocation == null) {
        throw Exception("Failed to get current location: 'Location not found'.");
      }
      await _channel.invokeMethod('moveToCurrentLocation', {'latitude': currentlocation.latitude, 'longitude': currentlocation.longitude});
    } on PlatformException catch (e) {
      throw Exception("Failed to move to current location: '${e.message}'.");
    }
  }

  Future<void> addCustomMarker({
    required Widget child,
    required double latitude,
    required double longitude,
    required String markerId,
    bool? setIsIconClickable = false,
    bool? setIsAnimationEnable = false,
    bool? setIsInfoWindowDismissOnClick = false,
  }) async {
    try {
      ScreenshotController screenshotController = ScreenshotController();
      var capturedImage = await screenshotController.captureFromWidget(child);
      var bytes = capturedImage.buffer.asUint8List();

      await _channel.invokeMethod('addMarker', {
        'markerId': markerId,
        'latitude': latitude,
        'longitude': longitude,
        'imageBytes': bytes,
        "setIsIconClickable": setIsIconClickable,
        "setIsAnimationEnable": setIsAnimationEnable,
        "setIsInfoWindowDismissOnClick": setIsInfoWindowDismissOnClick,
      });
    } on PlatformException catch (e) {
      throw Exception("Failed to add custom marker: '${e.message}'.");
    }
  }

  // Utility to capture widget as image

  //removeMarker
  Future<void> removeMarker({required String markerId}) async {
    try {
      await _channel.invokeMethod('removeMarker', {'markerId': markerId});
    } on PlatformException catch (e) {
      throw Exception("Failed to remove marker: '${e.message}'.");
    }
  }

  Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onError":
        String error = call.arguments;
        print("Error: $error");
        // Handle the error
        break;
      case "onMapReady":
        // Handle map ready state
        break;
    }
  }
}

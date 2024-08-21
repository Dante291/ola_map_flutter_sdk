import 'package:location/location.dart';

Future<LocationData?> checkLocationPermission() async {
  Location location = Location();

  // bool _serviceEnabled;
  // PermissionStatus _permissionGranted;
  LocationData locationData;

  // _serviceEnabled = await location.serviceEnabled();
  // if (!_serviceEnabled) {
  //   _serviceEnabled = await location.requestService();
  //   if (!_serviceEnabled) {
  //     return null;
  //   }
  // }

  // _permissionGranted = await location.hasPermission();
  // if (_permissionGranted == PermissionStatus.denied) {
  //   _permissionGranted = await location.requestPermission();
  //   if (_permissionGranted != PermissionStatus.granted) {
  //     return null;
  //   }
  // }

  locationData = await location.getLocation();

  return locationData;
}

import 'package:geolocator/geolocator.dart';

Future<Position?> checkLocationPermission() async {
  return await Geolocator.getCurrentPosition();
}

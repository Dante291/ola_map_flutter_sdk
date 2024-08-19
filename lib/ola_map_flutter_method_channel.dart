import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ola_map_flutter_platform_interface.dart';

/// An implementation of [OlaMapFlutterPlatform] that uses method channels.
class MethodChannelOlaMapFlutter extends OlaMapFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ola_map_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('initializeMap', {"apiKey": "4moGUXCK31I0On7PLAOAlX7RhdTPKig9IrsRvE36"});
    return version;
  }
}

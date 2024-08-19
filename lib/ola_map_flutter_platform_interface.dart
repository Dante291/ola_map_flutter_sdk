import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ola_map_flutter_method_channel.dart';

abstract class OlaMapFlutterPlatform extends PlatformInterface {
  /// Constructs a OlaMapFlutterPlatform.
  OlaMapFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static OlaMapFlutterPlatform _instance = MethodChannelOlaMapFlutter();

  /// The default instance of [OlaMapFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelOlaMapFlutter].
  static OlaMapFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OlaMapFlutterPlatform] when
  /// they register themselves.
  static set instance(OlaMapFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

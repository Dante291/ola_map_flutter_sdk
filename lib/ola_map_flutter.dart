
import 'ola_map_flutter_platform_interface.dart';

class OlaMapFlutter {
  Future<String?> getPlatformVersion() {
    return OlaMapFlutterPlatform.instance.getPlatformVersion();
  }
}

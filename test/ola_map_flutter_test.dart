// import 'package:flutter_test/flutter_test.dart';
// import 'package:ola_map_flutter/ola_map_flutter.dart';
// import 'package:ola_map_flutter/ola_map_flutter_platform_interface.dart';
// import 'package:ola_map_flutter/ola_map_flutter_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockOlaMapFlutterPlatform
//     with MockPlatformInterfaceMixin
//     implements OlaMapFlutterPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final OlaMapFlutterPlatform initialPlatform = OlaMapFlutterPlatform.instance;

//   test('$MethodChannelOlaMapFlutter is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelOlaMapFlutter>());
//   });

//   test('getPlatformVersion', () async {
//     OlaMapFlutter olaMapFlutterPlugin = OlaMapFlutter();
//     MockOlaMapFlutterPlatform fakePlatform = MockOlaMapFlutterPlatform();
//     OlaMapFlutterPlatform.instance = fakePlatform;

//     expect(await olaMapFlutterPlugin.getPlatformVersion(), '42');
//   });
// }

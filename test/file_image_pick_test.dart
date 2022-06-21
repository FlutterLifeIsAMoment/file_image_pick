import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_image_pick/file_image_pick.dart';

void main() {
  const MethodChannel channel = MethodChannel('fw.file.image.pick');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}

import 'package:flutter/services.dart';
import 'package:flutter_electronicid/flutter_electronicid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_electronicid');
  const endpoint = 'https://etrust-sandbox.electronicid.eu/v2';

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('checkRequirements', () async {
    expect(await FlutterElectronicId.checkRequirements(endpoint), true);
  });
}

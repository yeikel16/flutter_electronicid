# flutter_electronicid

[![pub package](https://img.shields.io/pub/v/flutter_electronicid.svg)](https://pub.dev/packages/flutter_electronicid)

Wrapper around the [Electronic ID](https://www.electronicid.eu/) Android and iOS SDKs for Flutter.

## Usage

```dart
import 'package:flutter_electronicid/flutter_electronicid.dart';

// ...

const endpoint = 'https://etrust-sandbox.electronicid.eu/v2';

void openVideoId() async {
  final videoId = await FlutterElectronicId.openVideoID(
    configuration: VideoIDConfiguration(
    authorization: '<your electronic ID authorization token>',
      language: 'en',
      endpoint: endpoint,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Video ID OK: $videoId'),
  ));
}

void checkRequirements() async {
  final success = await FlutterElectronicId.checkRequirements(endpoint);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Video ID Requirements Passed: $success'),
  ));
}
```

See [./example/lib/main.dart](./example/lib/main.dart) for a complete example.

## Development

For full IDE support during development, make sure to add the following to the `local.properties` file in `./example/android`

```
sdk.dir=<path_to_android_sdk>
flutter.sdk=<path_to_repository>/flutter_electronicid/.fvm/flutter_sdk
```

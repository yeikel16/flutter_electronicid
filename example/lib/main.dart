import 'package:flutter/material.dart';
import 'package:flutter_electronicid/flutter_electronicid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const endpoint = 'https://etrust-sandbox.electronicid.eu/v2';

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  void openVideoId() async {
    final videoId = await FlutterElectronicid.openVideoID(
      configuration: VideIDConfiguration(
        authorization: '<your electronic ID authorization token>',
        language: 'en',
        endpoint: endpoint,
      ),
    );
    print(videoId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Video ID OK: $videoId'),
    ));
  }

  void checkRequirements() async {
    final success = await FlutterElectronicid.checkRequirements(endpoint);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Video ID Requirements Passed: $success'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Electronic ID example app'),
        ),
        body: Center(
          child: Column(
            children: [
              GestureDetector(
                child: Text('Check VideoID Requirements'),
                onTap: checkRequirements,
              ),
              ElevatedButton(
                child: Text('Open VideoID'),
                onPressed: openVideoId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

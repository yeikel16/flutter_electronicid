import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_electronicid/flutter_electronicid.dart';

const endpoint = 'https://etrust-sandbox.electronicid.eu/v2/';
const authorization = '<YOUR ELECTRONIC ID AUTHORIZATION TOKEN>';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void showError(String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void openVideoId() async {
    showSnackBar('Opening VideoID...');
    try {
      final videoId = await FlutterElectronicId.openVideoID(
        configuration: VideoIDConfiguration(
          authorization: authorization,
          language: 'en',
          endpoint: endpoint,
        ),
      );
      showSnackBar('Video ID OK: $videoId');
    } catch (e) {
      if (kDebugMode) print(e);
      showError(e.toString());
    }
  }

  void checkRequirements() async {
    showSnackBar('Checking VideoID Requirements...');
    final success = await FlutterElectronicId.checkRequirements(endpoint);
    showSnackBar('Video ID Requirements Passed: $success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electronic ID example app'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: checkRequirements,
              child: const Text('Check VideoID Requirements'),
            ),
            ElevatedButton(
              onPressed: openVideoId,
              child: const Text('Open VideoID'),
            ),
          ],
        ),
      ),
    );
  }
}

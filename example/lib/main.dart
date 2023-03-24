import 'dart:developer';

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

  void launchSdk<R>({
    required String name,
    required Future<R?> Function() action,
  }) async {
    try {
      final resultId = await action.call();
      showSnackBar('$name: $resultId');
    } catch (e) {
      showError(e.toString());
      if (kDebugMode) log(e.toString());
    }
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
              child: const Text('Check VideoID Requirements'),
              onPressed: () {
                launchSdk(
                  name: 'Check VideoID Requirements',
                  action: () {
                    showSnackBar('Start check VideoID requirements ...');
                    return FlutterElectronicId.checkRequirements(
                      endpoint,
                    );
                  },
                );
              },
            ),
            ElevatedButton(
              child: const Text('Open VideoID'),
              onPressed: () {
                launchSdk(
                  name: 'Open VideoID',
                  action: () => FlutterElectronicId.openVideoID(
                    configuration: VideoIDConfiguration(
                      authorization: authorization,
                      language: 'en',
                      endpoint: endpoint,
                      defaultDocument: 251, // German residence permit
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Open VideoID Medium'),
              onPressed: () {
                launchSdk(
                  name: 'VideoID Medium',
                  action: () => FlutterElectronicId.openVideoIdMedium(
                    configuration: VideoIDConfiguration(
                      authorization: authorization,
                      language: 'en',
                      endpoint: endpoint,
                      defaultDocument: 251, // German residence permit
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

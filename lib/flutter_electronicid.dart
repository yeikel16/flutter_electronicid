import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterElectronicid {
  static const MethodChannel _channel =
      const MethodChannel('flutter_electronicid');

  static Future<String?> openVideoID(
      {VideIDConfiguration? configuration,
      Map<String, dynamic>? serialization}) async {
    final result = await _channel.invokeMethod('openVideoID', {
      'configuration': configuration?.toJson(),
      'serialization': serialization == null
          ? null
          : Platform.isIOS
              ? serialization
              : jsonEncode(serialization)
    });
    return result == null ? null : result;
  }

  static Future<bool> checkRequirements(String endpoint) async {
    final bool success = await _channel.invokeMethod('checkRequirements', {
      'endpoint': endpoint,
    });
    return success;
  }
}

class VideIDConfiguration {
  VideIDConfiguration({
    required this.endpoint,
    required this.authorization,
    required this.language,
    this.document,
  });

  final String endpoint;
  final String authorization;
  final String language;
  final String? document;

  Map<String, dynamic> toJson() {
    return {
      "endpoint": endpoint,
      "authorization": authorization,
      "language": language,
      "document": document ?? null,
    }..removeWhere((key, value) => value == null);
  }
}

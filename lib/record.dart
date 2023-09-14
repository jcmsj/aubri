import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';
import 'package:record/record.dart';

final record = AudioRecorder();
Future<Stream<Uint8List>> start() async {
// Check and request permission if needed
  if (await record.hasPermission()) {
    // ... or to stream
    final stream = await record
        .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
    return stream;
  }

  return Stream.error("Permission not granted");
}

void stopStream() {
  record.stop();
  record.dispose();
}

Future<ServerSocket> makeAudioServer(Registration r) async {
  final stream = await start();
  final ss = await ServerSocket.bind(InternetAddress.anyIPv4, r.service.port!);
  ss.listen((client) {
    print("$client connected");
    client.addStream(stream);
  });
  return ss;
}

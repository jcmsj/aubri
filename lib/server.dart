import 'dart:io';

import 'package:aubri/record.dart';
import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';

class AubriService {
  late Registration registration;
  static const name = 'Aubri';
  static const type = '_aubri._tcp';

  static Future<AubriService> init() async {
    final aubri = AubriService();
    aubri.registration =
        await register(const Service(name: name, type: type, port: 56000));
    return aubri;
  }

  stop() async {
    await unregister(registration);
  }
}

class ServerPage extends StatefulWidget {
  const ServerPage({super.key});
  @override
  State<ServerPage> createState() => ServiceState();
}

class ServiceState extends State<ServerPage> {
  AubriService? aubri;
  ServerSocket? server;
  @override
  void initState() {
    super.initState();
    reinit();
  }

  void reinit() {
    AubriService.init().then((it) async {
      setState(() async {
        aubri = it;
        server = await makeAudioServer(aubri!.registration);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Aubri is running.'),
          const Text('Press the button to stop the server.'),
          Text(server?.address.address ?? ''),
          Text(aubri?.registration.service.type ?? ''),
        ],
      ),
    );
  }

  @override
  void activate() {
    // TODO: implement activate
    super.activate();
    reinit();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    aubri?.stop();
    server?.close();
  }
}

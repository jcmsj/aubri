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
  @override
  void initState() {
    super.initState();
    AubriService.init().then((it) => aubri = it);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Aubri is running.'),
          const Text('Press the button to stop the server.'),
          Text(aubri?.registration.service.type ?? ''),
        ],
      ),
    );
  }
}

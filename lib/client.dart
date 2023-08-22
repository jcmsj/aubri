import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';

// make a stateful widget that shows the text 'player'

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});
  @override
  State<ClientPage> createState() => ClientState();
}

class ClientState extends State<ClientPage> {
  late Registration r;
  late Discovery d;
  String status = "nil";
  List<String> servers = [];
  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  void asyncInitState() async {
    d = await startDiscovery('_aubri._tcp');

    d.addListener(() {
      // discovery.services contains discovered services
      var ss = <String>[];
      for (var s in d.services) {
        if (!servers.contains(s.name)) {
          ss.add("${s.name}@${s.host}");
        }
      }
      setState(() {
        servers = ss;
        status = servers.join("\n");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(status),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
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
  late Socket s;
  String address = "";
  String status = "nil";
  List<String> servers = [];
  AudioPlayer player = AudioPlayer();
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
          Text(address),
          ListView.builder(
            shrinkWrap: true,
            itemCount: servers.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  onTap: () async {
                    final service = d.services.elementAt(index);
                    print("Connecting to ${service.host}:${service.port!}");
                    s = await Socket.connect(service.host, service.port!);
                    // play the stream using audioplayers
                    s.listen((event) {
                      //TODO
                    });
                    setState(() {
                      address = servers[index];
                    });
                  },
                  title: Text(servers[index]));
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

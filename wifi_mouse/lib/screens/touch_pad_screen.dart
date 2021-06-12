import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_mouse/packet.dart';
import 'package:wifi_mouse/utils/connection_utils.dart';

class TouchPadScreen extends StatefulWidget {
  @override
  _TouchPadScreenState createState() => _TouchPadScreenState();
}

class _TouchPadScreenState extends State<TouchPadScreen>
    implements ConnectionObserver {
  int prevX = 0;
  int prevY = 0;
  var isConnected = true;

  @override
  void initState() {
    super.initState();
    isConnected = ConnectionUtils.shared.isConnected;
    ConnectionUtils.shared.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TouchPad"),
        actions: [
          getConnectionStatusButton(),
          getOrientationSwitcherButton(context)
        ],
      ),
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (PointerEvent event) {
          prevX = event.position.dx.round();
          prevY = event.position.dy.round();
        },
        onPointerMove: (PointerEvent event) {
          var newX = event.position.dx.round();
          var newY = event.position.dy.round();
          var dx = newX - prevX;
          var dy = newY - prevY;
          ConnectionUtils.shared
              .sendPacket(new Packet("01", message: "$dx $dy"));
          prevX = newX;
          prevY = newY;
        },
        onPointerUp: (PointerEvent event) {},
      ),
    );
  }

  IconButton getConnectionStatusButton() {
    return IconButton(
      onPressed: () {
        ConnectionUtils.shared.connectToServer();
      },
      icon: Icon(isConnected ? Icons.laptop_mac : Icons.language_rounded),
      color: isConnected ? Colors.green : Colors.red,
    );
  }

  IconButton getOrientationSwitcherButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (MediaQuery.of(context).orientation == Orientation.portrait) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight
            ]);
          } else {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
          }
        },
        icon: Icon(Icons.screen_rotation_rounded));
  }

  @override
  void onConnected() {
    isConnected = true;
    setState(() {});
  }

  @override
  void onDisconnected() {
    isConnected = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    ConnectionUtils.shared.removeObserver(this);
  }
}

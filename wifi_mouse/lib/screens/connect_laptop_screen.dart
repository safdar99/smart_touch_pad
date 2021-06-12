import 'package:flutter/material.dart';
import 'package:wifi_mouse/utils/connection_utils.dart';

class ConnectLaptopScreen extends StatefulWidget {
  @override
  _ConnectLaptopScreenState createState() => _ConnectLaptopScreenState();
}

class _ConnectLaptopScreenState extends State<ConnectLaptopScreen>
    implements ConnectionObserver {
  final controller = TextEditingController();
  var connectionStatus = "Not connected to any laptop";

  @override
  void initState() {
    super.initState();
    if (ConnectionUtils.shared.isConnected) {
      connectionStatus = "Connected";
    } else {
      connectionStatus = "Disconnected";
    }
    ConnectionUtils.shared.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(connectionStatus),
          actions: [getCloseConnectionButton()],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getIdAddressField(),
              getConnectButton(),
              getGoToTouchPadButton(context)
            ],
          ),
        ));
  }

  TextButton getGoToTouchPadButton(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.of(context).pushNamed("/touchPad"),
        child: Text("Go to Touch Pad"));
  }

  TextButton getCloseConnectionButton() {
    return TextButton(
        onPressed: () {
          ConnectionUtils.shared.closeConnection();
        },
        child: Text("Close", style: TextStyle(color: Colors.white)));
  }

  Widget getIdAddressField() {
    return TextField(
      decoration: InputDecoration(hintText: "Enter IP Adress of laptop"),
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      controller: controller,
    );
  }

  Widget getConnectButton() {
    return TextButton(
        onPressed: () {
          final serverIp = controller.text;
          connectionStatus = "Trying to connect to $serverIp ...";
          setState(() {});
          ConnectionUtils.shared.connectToServer(ip: serverIp, port: 3000);
        },
        child: Text("Connect"));
  }

  @override
  void onConnected() {
    connectionStatus = "Connected!!";
    setState(() {});
  }

  @override
  void onDisconnected() {
    connectionStatus = "Disconnected!!";
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    ConnectionUtils.shared.removeObserver(this);
  }
}

import 'dart:io';

import 'package:wifi_mouse/packet.dart';

class ConnectionUtils {
  static final shared = ConnectionUtils._();
  var _lastServerIp = "";
  var _lastPort = -1;
  List<ConnectionObserver> _observers = [];
  bool isConnected = false;

  Socket _socket;

  ConnectionUtils._();

  void connectToServer({String ip = "", int port = -1}) async {
    try {
      ip = ip != "" ? ip : _lastServerIp;
      port = port != -1 ? port : _lastPort;
      _socket = await Socket.connect(ip, port);
      attachSocketStatusListener();
      notifyConnected();
      _lastServerIp = ip;
      _lastPort = port;
    } catch (error) {
      notifyDisconnected();
    }
  }

  void attachSocketStatusListener() {
    _socket.listen((event) {}, onDone: () {}, onError: (error) {
      notifyDisconnected();
    });
  }

  void sendPacket(Packet packet) {
    try {
      _socket.write(packet.getString());
      notifyConnected();
    } catch (error) {}
  }

  void addObserver(ConnectionObserver observer) {
    _observers.add(observer);
  }

  bool removeObserver(ConnectionObserver observer) {
    return _observers.remove(observer);
  }

  void closeConnection() {
    try {
      _socket.write(new Packet("02").getString());
      _socket.close();
      notifyDisconnected();
    } catch (error) {}
  }

  void notifyConnected() {
    isConnected = true;
    for (ConnectionObserver observer in _observers) {
      observer.onConnected();
    }
  }

  void notifyDisconnected() {
    isConnected = false;
    for (ConnectionObserver observer in _observers) {
      observer.onDisconnected();
    }
  }
}

abstract class ConnectionObserver {
  void onConnected();
  void onDisconnected();
}

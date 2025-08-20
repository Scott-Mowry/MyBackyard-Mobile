import 'dart:developer';
import 'package:backyard/Controller/user_controller.dart';
import 'package:backyard/main.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'api.dart';
import 'socket_navigation_class.dart';

class SocketService {
  static Socket? _socket;

  SocketService._();

  static SocketService? _instance;

  static SocketService? get instance {
    _instance ??= SocketService._();
    return _instance;
  }

  Socket? get socket => _socket;

  void initializeSocket() {
    _socket = io(API.socket_url, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
  }

  void connectSocket() {
    _socket?.connect();
    _socket?.on("connect", (data) {
      log('Connected socket ');
    });

    _socket?.on("disconnect", (data) {
      log('Disconnected $data');
    });

    _socket?.on("connect_error", (data) {
      log('Connect Error $data');
    });

    _socket?.on("error", (data) {
      log('Error $data');
      SocketNavigationClass.instance?.socketErrorMethod(errorResponseData: data);
    });
  }

  void socketEmitMethod({required String eventName, required dynamic eventParamaters}) {
    _socket?.emit(eventName, eventParamaters);
  }

  void socketResponseMethod() {
    _socket?.on("response", (data) => SocketNavigationClass.instance?.socketResponseMethod(responseData: data));
  }

  void userResponse() {
    socket?.on(
      "response_${navigatorKey.currentContext?.read<UserController>().user?.id?.toString()}",
      (data) => SocketNavigationClass.instance?.socketUserResponseMethod(responseData: data),
    );
  }

  void dispose() {
    _socket?.dispose();
  }
}

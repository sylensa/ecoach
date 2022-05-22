import 'dart:async';
import 'dart:convert';

import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/websocket/event_data.dart';
import 'package:web_socket_channel/io.dart';

class WebsocketCall {
  static const CONNECTION_ESTABLISHED = "pusher:connection_established";
  static const CLIENT_GENERAL = "client-general";
  static const CLIENT_MESSAGE = "client-message";
  static const CLIENT_WEBRTC = "client-webrtc";

  WebsocketCall._privateConstructor();

  static final WebsocketCall _instance = WebsocketCall._privateConstructor();

  factory WebsocketCall() {
    return _instance;
  }

  IOWebSocketChannel? _channel;
  List<WebsocketListener> listeners = [];
  User? user;
  String? channel;

  connect({Completer? completer, required user, required String channel}) {
    print("connecting websocket ....");
    this.user = user;
    this.channel = channel;

    if (_channel == null) {
      _channel = IOWebSocketChannel.connect(Uri.parse(AppUrl.websocket));
      print('connecting ....');
      _channel!.stream.listen((event) async {
        print(event);
        var pushObject = eventDataFromJson(event);
        print(pushObject.event);

        if (pushObject.event == CONNECTION_ESTABLISHED) {
          if (user != null) {
            subscribe(channel);
          }
        } else if (pushObject.channel == channel) {
          print("channel is good");

          listeners.forEach((listener) {
            listener.eventHandler(pushObject);
          });
        } else if (pushObject.event == ".new_subscriber") {
          listeners.forEach((listener) {
            listener.eventHandler(pushObject);
          });
        }
      }, onError: (error) {
        print("Websocket is on error");
        print(error);
      }, onDone: () {
        print("Websocket is done");
        _channel!.sink.close();
        _channel = null;
        disconnect();
        if (completer != null) {
          completer.complete(true);
        }
      });
    }
    Future.delayed(Duration(seconds: 4)).then((value) {
      subscribeTemp("test");
    });
  }

  disconnect() {
    listeners = [];
  }

  addListener(WebsocketListener listener) {
    listeners.add(listener);
  }

  removeListener(WebsocketListener listener) {
    listeners.remove(listener);
  }

  add(event) {
    _channel!.sink.add(event);
  }

  subscribe(String channel) {
    print("subscribing  to channel $channel");
    var data =
        "{\"event\":\"pusher:subscribe\",\"data\":{\"user\":${jsonEncode(user!.id)},\"channel\":\"${jsonEncode(user!.id)}.subscription\"}}";
    _channel!.sink.add(data);
  }

  subscribeTemp(String channel) {
    print("subscribing  to channel $channel");
    var data =
        "{\"event\":\"SubscriptionPurchasedNotification\",\"channel\":\"$channel\",\"data\":${jsonEncode(user!.id)}-subscription}";
    _channel!.sink.add(data);
  }

  sendMessage(String message) {
    var data =
        "{\"event\":\"client-message\",\"channel\":\"youth\",\"data\":{\"message\":\"$message\"}}";
    _channel!.sink.add(data);
  }

  sendData(
    dynamic data, {
    required String event,
    String type = '\"game\"',
  }) {
    var json =
        "{\"event\":${jsonEncode(event)},\"channel\":${jsonEncode(channel)},\"user-id\":${jsonEncode(user!.id)},\"type\":$type,\"data\":${jsonEncode(data)}}";
    _channel!.sink.add(json);
  }
}

abstract class WebsocketListener {
  eventHandler(EventData event);
}

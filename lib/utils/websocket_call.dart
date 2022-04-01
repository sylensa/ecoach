import 'dart:async';
import 'dart:convert';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/notification_service.dart';
import 'package:ecoach/utils/shared_preference.dart';
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

  connect({Completer? completer}) {
    var userId;
    if (_channel == null) {
      _channel = IOWebSocketChannel.connect(AppUrl.websocketIpURL);
      _channel!.stream.listen((event) async {
        print(event);
        var pushObject = jsonDecode(event);

        if (pushObject['event'].toString().startsWith('pusher_internal')) {
          return;
        }
        if (pushObject['event'] == CONNECTION_ESTABLISHED) {
          var user = await UserPreferences().getUser();
          if (user != null) {
            userId = user.id;
            subscribe("inbox-$userId");
            subscribe("friends-$userId");
          }
        } else if (pushObject['channel']
            .toString()
            .startsWith('subscription')) {
          var innerData = jsonDecode(pushObject['data']);
          print(innerData);
          print('received inbox event');
          print(jsonDecode(pushObject["data"]));
          var inbox = Subscription.fromJson(innerData["data"]);
          var previousInbox = await SubscriptionDB().getMessageById(inbox.id!);
          if (previousInbox == null) {
            var data =
                "{\"event\":\"confirm-response\",\"type\":\"inbox\",\"user_id\":$userId,\"id\":${inbox.id},\"channel\":\"inbox-$userId\"}";
            SubscriptionDB().insert(inbox);
            User? user = await UserPreferences().getUser();
            NotificationService().showNotification(
                'Bundle bought from ${user!.name!}',
                inbox.name,
                "inbox-${inbox.id}");
            _channel!.sink.add(data);
            // NotificationDB().insert(new HomeNotification(
            //     image: inbox.from!.profileImage!,
            //     title: '${inbox.from!.name!}',
            //     text: inbox.text,
            //     dataId: inbox.id,
            //     type: 'inbox',
            //     createdAt: DateTime.now()));
          }
        }

        if (listeners.length > 0) {
          listeners.forEach((listener) {
            listener.eventHandler(event);
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
        "{\"event\":\"pusher:subscribe\",\"data\":{\"auth\":\":ag-youth\",\"channel\":\"$channel\"}}";
    _channel!.sink.add(data);
  }

  sendJson(Map<String, dynamic> message) {
    var data =
        "{\"event\":\"client-message\",\"channel\":\"youth\",\"data\":$message}";
    _channel!.sink.add(data);
  }

  sendMessage(String message) {
    var data =
        "{\"event\":\"client-message\",\"channel\":\"youth\",\"data\":{\"message\":\"$message\"}}";
    _channel!.sink.add(data);
  }
}

abstract class WebsocketListener {
  eventHandler(event);
}

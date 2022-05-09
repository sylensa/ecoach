// To parse this JSON data, do
//
//     final eventData = eventDataFromJson(jsonString);

import 'dart:convert';

EventData eventDataFromJson(String str) => EventData.fromJson(json.decode(str));

String eventDataToJson(EventData data) => json.encode(data.toJson());

class EventData {
  EventData({
    this.event,
    this.channel,
    this.playerId,
    this.type,
    this.data,
    this.dataJson,
  });

  String? event;
  String? channel;
  String? playerId;
  String? type;
  dynamic data;

  Map<String, dynamic>? dataJson;

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      event: json["event"],
      channel: json["channel"],
      playerId: json["player-id"],
      type: json["type"],
      data: json['data'],
    );
  }

  Map<String, dynamic> getRawData(Function(Map<String, dynamic>) create) {
    return create(dataJson!);
  }

  Map<String, dynamic> toJson() => {
        "event": event,
        "channel": channel,
        "player-id": playerId,
        "type": type,
      };
}

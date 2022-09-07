// To parse this JSON data, do
//
//     final getChatBetween = getChatBetweenFromJson(jsonString);

import 'dart:convert';

GetChatBetween getChatBetweenFromJson(String? str) => GetChatBetween.fromJson(json.decode(str!));

String? getChatBetweenToJson(GetChatBetween data) => json.encode(data.toJson());

class GetChatBetween {
  GetChatBetween({
    this.status,
    this.messages,
  });

  bool? status;
  List<Messages>? messages;

  factory GetChatBetween.fromJson(Map<String, dynamic> json) => GetChatBetween(
    status: json["status"] == null ? null : json["status"],
    messages: json["messages"] == null ? null : List<Messages>.from(json["messages"].map((x) => Messages.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "messages": messages == null ? null : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Messages {
  Messages({
    this.mid,
    this.stamp,
    this.mediatype,
    this.mediasize,
    this.sender,
    this.message,
    this.isMedia,
    this.receiver,
    this.gid,
    this.senderName,
    this.senderDp,
  });

  String? mid;
  DateTime? stamp;
  String? mediatype;
  String? mediasize;
  String? sender;
  String? senderName;
  String? senderDp;
  String? message;
  String? isMedia;
  String? receiver;
  String? gid;

  chatBetweenModelMap(){
    var mapping = Map<String, dynamic>();
    mapping['mid'] = mid;
    mapping['stamp'] = stamp.toString();
    mapping['mediatype'] = mediatype;
    mapping['mediasize'] = mediasize;
    mapping['sender'] = sender;
    mapping['sender_name'] = senderName;
    mapping['sender_dp'] = senderDp;
    mapping['message'] = message;
    mapping['is_media'] = isMedia;
    mapping['receiver'] = receiver;
    return mapping;
  }

  groupChatBetweenModelMap(){
    var mapping = Map<String, dynamic>();
    mapping['mid'] = mid;
    mapping['gid'] = gid;
    mapping['stamp'] = stamp.toString();
    mapping['mediatype'] = mediatype;
    mapping['mediasize'] = mediasize;
    mapping['sender'] = sender;
    mapping['message'] = message;
    mapping['is_media'] = isMedia;
    mapping['receiver'] = receiver;
    mapping['sender_name'] = senderName;
    mapping['sender_dp'] = senderDp;
    return mapping;
  }

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    mid: json["mid"] == null ? "" : json["mid"],
    gid: json["gid"] == null ? "" : "",
    stamp: json["stamp"] == null ? DateTime.now() : DateTime.parse(json["stamp"]),
    mediatype: json["mediatype"] == null ? "" : json["mediatype"],
    mediasize: json["mediasize"] == null ? "null" : json["mediasize"],
    sender: json["sender"] == null ? "null" : json["sender"],
    message: json["message"] == null ? "null" : json["message"],
    isMedia: json["is_media"] == null ? "null" : json["is_media"],
    senderName: json["sender_name"] == null ? "null" : json["sender_name"],
    senderDp: json["sender_dp"] == null ? "null" : json["sender_dp"],
    receiver: json["receiver"] == null ? "null" : json["receiver"],
  );

  Map<String, dynamic> toJson() => {
    "mid": mid == null ? null : mid,
    "gid": gid == null ? "" : "",
    "stamp": stamp == null ? "null" : stamp!.toIso8601String(),
    "mediatype": mediatype == null ? "null" : mediatype,
    "mediasize": mediasize == null ? "null" : mediasize,
    "sender": sender == null ? "null" : sender,
    "message": message == null ? "null" : message,
    "is_media": isMedia == null ? "null" : isMedia,
    "sender_dp": senderDp == null ? "null" : senderDp,
    "sender_name": senderName == null ? "null" : senderName,
    "receiver": receiver == null ? "null" : receiver,
  };
}

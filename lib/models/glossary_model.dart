// To parse this JSON data, do
//
//     final glossaryModel = glossaryModelFromJson(jsonString);

import 'dart:convert';

GlossaryModel glossaryModelFromJson(String? str) => GlossaryModel.fromJson(json.decode(str!));

String? glossaryModelToJson(GlossaryModel data) => json.encode(data.toJson());

class GlossaryModel {
  GlossaryModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  bool? status;
  String? code;
  String? message;
  List<GlossaryData>? data;

  factory GlossaryModel.fromJson(Map<String, dynamic> json) => GlossaryModel(
    status: json["status"] == null ? null : json["status"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<GlossaryData>.from(json["data"].map((x) => GlossaryData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GlossaryData {
  GlossaryData({
    this.id,
    this.term,
    this.definition,
    this.topicId,
    this.courseId,
    this.editorId,
    this.createdAt,
    this.updatedAt,
    this.flagged,
    this.public,
    this.confirmed,
    this.userSavesCount,
    this.likesCount,
    this.dislikesCount,
    this.isSaved,
    this.isLiked,
    this.keywordAppearance,
    this.keywordRank,
    this.topic,
    this.definitions,
    this.resources,
    this.glossary,
    this.isPinned,
  });

  int? id;
  String? term;
  String? definition;
  int? topicId;
  int? courseId;
  int? editorId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? flagged;
  int? public;
  int? confirmed;
  int? userSavesCount;
  int? likesCount;
  int? dislikesCount;
  int? isSaved;
  int? isPinned;
  int? isLiked;
  int? keywordAppearance;
  String? keywordRank;
  String? glossary;
  Topics? topic;
  List<Definition>? definitions;
  List<Resource>? resources;


  glossaryDataDataMap(){
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['course_id'] = courseId;
    mapping['topic_id'] = topicId;
    mapping['glossary'] = glossary;
    return mapping;
  }

  factory GlossaryData.fromJson(Map<String, dynamic> json) => GlossaryData(
    id: json["id"] == null ? null : json["id"],
    term: json["term"] == null ? null : json["term"],
    definition: json["definition"] == null ? null : json["definition"],
    topicId: json["topic_id"] == null ? null : json["topic_id"],
    isPinned: json["is_pinned"] == null ? 0 : json["is_pinned"],
    courseId: json["course_id"] == null ? null : json["course_id"],
    editorId: json["editor_id"] == null ? null : json["editor_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    flagged: json["flagged"] == null ? null : json["flagged"],
    public: json["public"] == null ? null : json["public"],
    confirmed: json["confirmed"] == null ? null : json["confirmed"],
    userSavesCount: json["user_saves_count"] == null ? null : json["user_saves_count"],
    likesCount: json["likes_count"] == null ? null : json["likes_count"],
    dislikesCount: json["dislikes_count"] == null ? null : json["dislikes_count"],
    isSaved: json["is_saved"] == null ? null : json["is_saved"],
    isLiked: json["is_liked"] == null ? null : json["is_liked"],
    keywordAppearance: json["keyword_appearance"] == null ? null : json["keyword_appearance"],
    keywordRank: json["keyword_rank"] == null ? null : json["keyword_rank"],
    topic: json["topic"] == null ? null : Topics.fromJson(json["topic"]),
    definitions: json["definitions"] == null ? null : List<Definition>.from(json["definitions"].map((x) => Definition.fromJson(x))),
    resources: json["resources"] == null ? null : List<Resource>.from(json["resources"].map((x) => Resource.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "term": term == null ? null : term,
    "definition": definition == null ? null : definition,
    "topic_id": topicId == null ? null : topicId,
    "is_pinned": isPinned == null ? 0 : isPinned,
    "course_id": courseId == null ? null : courseId,
    "editor_id": editorId == null ? null : editorId,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "flagged": flagged == null ? null : flagged,
    "public": public == null ? null : public,
    "confirmed": confirmed == null ? null : confirmed,
    "user_saves_count": userSavesCount == null ? null : userSavesCount,
    "likes_count": likesCount == null ? null : likesCount,
    "dislikes_count": dislikesCount == null ? null : dislikesCount,
    "is_saved": isSaved == null ? null : isSaved,
    "is_liked": isLiked == null ? null : isLiked,
    "keyword_appearance": keywordAppearance == null ? null : keywordAppearance,
    "keyword_rank": keywordRank == null ? null : keywordRank,
    "topic": topic == null ? null : topic!.toJson(),
    "definitions": definitions == null ? null : List<dynamic>.from(definitions!.map((x) => x.toJson())),
    "resources": resources == null ? null : List<dynamic>.from(resources!.map((x) => x.toJson())),
  };
}

class Definition {
  Definition({
    this.id,
    this.glossaryId,
    this.definition,
  });

  int? id;
  int? glossaryId;
  String? definition;

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
    id: json["id"] == null ? null : json["id"],
    glossaryId: json["glossary_id"] == null ? null : json["glossary_id"],
    definition: json["definition"] == null ? null : json["definition"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "glossary_id": glossaryId == null ? null : glossaryId,
    "definition": definition == null ? null : definition,
  };
}

class Resource {
  Resource({
    this.id,
    this.glossaryId,
    this.type,
    this.url,
  });

  int? id;
  int? glossaryId;
  String? type;
  String? url;

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json["id"] == null ? null : json["id"],
    glossaryId: json["glossary_id"] == null ? null : json["glossary_id"],
    type: json["type"] == null ? null : json["type"],
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "glossary_id": glossaryId == null ? null : glossaryId,
    "type": type == null ? null : type,
    "url": url == null ? null : url,
  };
}



class Topics {
  Topics({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Topics.fromJson(Map<String, dynamic> json) => Topics(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };
}





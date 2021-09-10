class Question {
  Question({
    this.id,
    this.courseId,
    this.topicId,
    this.qid,
    this.text,
    this.instructions,
    this.resource,
    this.options,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.qtype,
    this.confirmed,
    this.public,
    this.flagged,
    this.deleted,
    this.editors,
  });

  int? id;
  int? courseId;
  int? topicId;
  String? qid;
  String? text;
  String? instructions;
  String? resource;
  String? options;
  int? position;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? qtype;
  int? confirmed;
  int? public;
  int? flagged;
  int? deleted;
  String? editors;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        courseId: json["course_id"],
        topicId: json["topic_id"],
        qid: json["qid"],
        text: json["text"],
        instructions: json["instructions"],
        resource: json["resource"],
        options: json["options"],
        position: json["position"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        qtype: json["qtype"],
        confirmed: json["confirmed"],
        public: json["public"],
        flagged: json["flagged"],
        deleted: json["deleted"],
        editors: json["editors"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "topic_id": topicId,
        "qid": qid,
        "text": text,
        "instructions": instructions,
        "resource": resource,
        "options": options,
        "position": position,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "qtype": qtype,
        "confirmed": confirmed,
        "public": public,
        "flagged": flagged,
        "deleted": deleted,
        "editors": editors,
      };
}

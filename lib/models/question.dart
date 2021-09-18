class Question {
  Question({
    this.id,
    this.courseId,
    this.topicId,
    this.topicName,
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
    this.answers,
  });

  int? id;
  int? courseId;
  int? topicId;
  String? topicName;
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
  List<Answer>? answers;
  Answer? selectedAnswer;

  Answer? get correctAnswer {
    for (int i = 0; i < answers!.length; i++) {
      if (answers![i].value == 1) {
        return answers![i];
      }
    }

    return null;
  }

  bool get isCorrect {
    return correctAnswer != null && correctAnswer == selectedAnswer;
  }

  bool get isWrong {
    return !unattempted && correctAnswer == selectedAnswer;
  }

  bool get unattempted {
    return selectedAnswer == null;
  }

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        courseId: json["course_id"],
        topicId: json["topic_id"],
        topicName: json["topic"] != null
            ? json['topic']['name']
            : "topic id: ${json["topic_id"]}",
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
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
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
        "answers": List<dynamic>.from(answers!.map((x) => x.toJson())),
      };
}

class Answer {
  Answer({
    this.id,
    this.questionId,
    this.text,
    this.value,
    this.solution,
    this.createdAt,
    this.updatedAt,
    this.answerOrder,
    this.responses,
    this.flagged,
    this.editors,
  });

  int? id;
  int? questionId;
  String? text;
  int? value;
  String? solution;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? answerOrder;
  int? responses;
  int? flagged;
  String? editors;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["id"],
        questionId: json["question_id"],
        text: json["text"],
        value: json["value"],
        solution: json["solution"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        answerOrder: json["answer_order"],
        responses: json["responses"],
        flagged: json["flagged"],
        editors: json["editors"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": questionId,
        "text": text,
        "value": value,
        "solution": solution,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "answer_order": answerOrder,
        "responses": responses,
        "flagged": flagged,
        "editors": editors,
      };
}

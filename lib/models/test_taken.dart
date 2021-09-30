class TestTaken {
  TestTaken(
      {this.id,
      required this.userId,
      this.datetime,
      this.courseId,
      this.testname,
      this.testType,
      this.testId,
      this.testTime,
      this.usedTime,
      this.pauseduration,
      required this.totalQuestions,
      this.score,
      this.correct,
      this.wrong,
      this.unattempted,
      required this.responses,
      this.comment,
      this.userRank,
      this.totalRank});

  int? id;
  int? userId;
  DateTime? datetime;
  int? courseId;
  String? testname;
  String? testType;
  int? testId;
  int? testTime;
  int? usedTime;
  int? pauseduration;
  int totalQuestions;
  double? score;
  int? correct;
  int? wrong;
  int? unattempted;
  String responses;
  String? comment;
  int? userRank;
  int? totalRank;

  factory TestTaken.fromJson(Map<String, dynamic> json) => TestTaken(
      id: json["id"],
      userId: json["user_id"],
      datetime: DateTime.parse(json["date_time"]),
      courseId: json["course_id"],
      testname: json["test_name"],
      testType: json["test_type"],
      testId: json["test_id"],
      testTime: json["test_time"],
      usedTime: json["used_time"],
      pauseduration: json["pause_duration"],
      totalQuestions: json["total_questions"],
      score: json["score"] != null ? double.parse("${json['score']}") : 0,
      correct: json["correct"],
      wrong: json["wrong"],
      unattempted: json["unattempted"],
      responses: json["responses"],
      comment: json["comment"],
      userRank: json['rank'] != null ? json['rank']['rank'] : null,
      totalRank: json['rank'] != null ? json['rank']['total'] : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "date_time": datetime!.toIso8601String(),
        "course_id": courseId,
        "test_name": testname,
        "test_type": testType,
        "test_id": testId,
        "test_time": testTime,
        "used_time": usedTime,
        "pause_duration": pauseduration,
        "total_questions": totalQuestions,
        "score": score,
        "correct": correct,
        "wrong": wrong,
        "unattempted": unattempted,
        "responses": responses,
        "comment": comment,
      };
}

class TestAnswer {
  TestAnswer({
    this.questionId,
    this.topicId,
    this.topicName,
    this.selectedAnswerId,
    this.status,
  });

  int? questionId;
  int? topicId;
  String? topicName;
  int? selectedAnswerId;
  String? status;

  bool get isCorrect {
    return status == "correct";
  }

  bool get isWrong {
    return status == "wrong";
  }

  bool get unattempted {
    return status == "unattempted";
  }

  factory TestAnswer.fromJson(Map<String, dynamic> json) => TestAnswer(
        questionId: json["question_id"],
        topicId: json["topic_id"],
        topicName: json["topic_name"],
        selectedAnswerId: json["selected_answer_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "topic_id": topicId,
        "topic_name": topicName,
        "selected_answer_id": selectedAnswerId,
        "status": status,
      };
}

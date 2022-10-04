class CourseCompletionProgressAttempt {
  int? id;
  int? revisionProgressId;
  int? studyId;
  int? topicId;
  int? courseId;
  String? topicName;
  double? score;
  DateTime? createdAt;
  DateTime? updated_at;

  CourseCompletionProgressAttempt({
    this.courseId,
    this.createdAt,
    this.id,
    this.revisionProgressId,
    this.score,
    this.studyId,
    this.topicId,
    this.topicName,
    this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "cc_progress_id": this.revisionProgressId,
      "study_id": this.studyId,
      "topic_id": this.topicId,
      "course_id": this.courseId,
      "topic_name": this.topicName,
      "score": this.score!.toInt(),
      "created_at": this.createdAt!.toIso8601String(),
      "updated_at": this.updated_at!.toIso8601String()
    };
  }

  CourseCompletionProgressAttempt.fromMap(Map<String, dynamic> map)
      : this.id = map['id'],
        this.revisionProgressId = map['cc_progress_id'],
        this.studyId = map['study_id'],
        this.topicId = map['topic_id'],
        this.courseId = map['course_id'],
        this.topicName = map['topic_name'],
        this.score = map['score'].toDouble(),
        this.createdAt = DateTime.parse(map['created_at']),
        this.updated_at = DateTime.parse(map['updated_at']);
}

class RevisionProgressAttempt {
  final int id;
  final int revisionProgressId;
  final int studyId;
  final int topicId;
  final int courseId;
  final String topicName;
  final double score;
  final DateTime createdAt;
  final DateTime updated_at;

  RevisionProgressAttempt({
    required this.courseId,
    required this.createdAt,
    required this.id,
    required this.revisionProgressId,
    required this.score,
    required this.studyId,
    required this.topicId,
    required this.topicName,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "revision_progress_id": this.revisionProgressId,
      "study_id": this.studyId,
      "topic_id": this.topicId,
      "course_id": this.courseId,
      "topic_name": this.topicName,
      "score": this.score,
      "created_at": this.createdAt,
      "updated_at": this.updated_at
    };
  }

  RevisionProgressAttempt.fromMap(Map<String, dynamic> map)
      : this.id = map['id'],
        this.revisionProgressId = map['revision_progress_id'],
        this.studyId = map['studyId'],
        this.topicId = map['topic_id'],
        this.courseId = map['course_id'],
        this.topicName = map['topic_name'],
        this.score = map['score'],
        this.createdAt = map['created_at'],
        this.updated_at = map['updated_at'];


}
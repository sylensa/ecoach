class CourseCompletionStudyProgress {
  final int id;
  final int studyId;
  final int topicId;
  final int courseId;
  final int level;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseCompletionStudyProgress({
    required this.courseId,
    required this.createdAt,
    required this.id,
    required this.level,
    required this.studyId,
    required this.topicId,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "study_id": this.studyId,
      "topic_id": this.topicId,
      "course_id": this.courseId,
      "level": this.level,
      "created_at": this.createdAt,
      "updated_at": this.updatedAt
    };
  }

  CourseCompletionStudyProgress.fromMap(Map<String, dynamic> map)
      : this.id = map["id"],
        this.studyId = map['study_id'],
        this.courseId = map["course_id"],
        this.topicId = map['topic_id'],
        this.createdAt = map["created_at"],
        this.updatedAt = map['updated_at'],
        this.level = map['level'];
}

import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/topic.dart';

class Report {
  Report({
    this.courseStats,
    this.topicStats,
  });

  List<CourseStat>? courseStats;
  List<TopicStat>? topicStats;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        courseStats: json['course_stats'] == null
            ? []
            : List<CourseStat>.from(
                json['course_stats'].map(
                  (stat) => CourseStat.fromJson(stat),
                ),
              ),
        topicStats: json['topics_stats'] == null
            ? []
            : List<TopicStat>.from(
                json['topics_stats'].map(
                  (stat) => TopicStat.fromJson(stat),
                ),
              ),
      );
}

class CourseStat {
  CourseStat({
    this.id,
    this.userId,
    this.courseId,
    this.totalCorrectQuestions,
    this.totalUniqueQuestions,
    this.totalQuestions,
    this.totalTests,
    this.totalTimeTaken,
    this.rankPoints,
    this.avgScore,
    this.avgTime,
    this.exposure,
    this.lastDate,
    this.createdAt,
    this.updatedAt,
    this.speed,
    this.rank,
    this.name,
  });

  int? id;
  int? userId;
  int? courseId;
  int? totalCorrectQuestions;
  int? totalUniqueQuestions;
  int? totalQuestions;
  int? totalTests;
  String? totalTimeTaken;
  String? rankPoints;
  String? avgScore;
  String? avgTime;
  String? exposure;
  String? lastDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? speed;
  String? name;
  int? rank;

  factory CourseStat.fromJson(Map<String, dynamic> json) => CourseStat(
        id: json['id'],
        userId: json['user_id'],
        courseId: json['course_id'],
        totalCorrectQuestions: json['total_correct_questions'],
        totalUniqueQuestions: json['total_unique_questions'],
        totalQuestions: json['total_questions'],
        totalTests: json['total_tests'],
        totalTimeTaken: json['total_time_taken'],
        rankPoints: json['rank_points'],
        avgScore: json['avg_score'],
        avgTime: json['avg_time'],
        exposure: json['exposure'],
        lastDate: json['last_date'],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        speed: json['speed'],
        rank: json['rank'],
        name: json['name'],
      );
}

class TopicStat {
  TopicStat({
    this.id,
    this.userId,
    this.courseId,
    this.totalCorrectQuestions,
    this.totalUniqueQuestions,
    this.totalQuestions,
    this.totalTests,
    this.totalTimeTaken,
    this.rankPoints,
    this.avgScore,
    this.avgTime,
    this.exposure,
    this.lastDate,
    this.createdAt,
    this.updatedAt,
    this.speed,
    this.rank,
    this.topic,
    this.course,
    this.testSource,
  });

  int? id;
  int? userId;
  int? courseId;
  int? totalCorrectQuestions;
  int? totalUniqueQuestions;
  int? totalQuestions;
  int? totalTests;
  int? totalTimeTaken;
  String? rankPoints;
  Topic? topic;
  Course? course;
  String? testSource;
  String? avgScore;
  String? avgTime;
  String? exposure;
  String? lastDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? speed;
  int? rank;

  factory TopicStat.fromJson(Map<String, dynamic> json) => TopicStat(
        id: json['id'],
        userId: json['user_id'],
        courseId: json['course_id'],
        totalCorrectQuestions: json['total_correct_questions'],
        totalUniqueQuestions: json['total_unique_questions'],
        totalQuestions: json['total_questions'],
        totalTests: json['total_tests'],
        totalTimeTaken: json['total_time_taken'],
        rankPoints: json['rank_points'],
        course: json["course"] == null ? null : Course.fromJson(json["course"]),
        topic: json["topic"] == null ? null : Topic.fromJson(json["topic"]),
        testSource: json['test_source'] ?? "Subscription",
        avgScore: json['avg_score'],
        avgTime: json['avg_time'],
        exposure: json['exposure'],
        lastDate: json['last_date'],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        speed: json['speed'],
        rank: json['rank'] ?? 0,
      );
}

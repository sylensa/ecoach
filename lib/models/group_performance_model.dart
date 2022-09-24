// // To parse this JSON data, do
// //
// //     final groupTestPerformanceModel = groupTestPerformanceModelFromJson(jsonString);
//
// import 'dart:convert';
//
// GroupTestPerformanceModel groupTestPerformanceModelFromJson(String? str) => GroupTestPerformanceModel.fromJson(json.decode(str!));
//
// String? groupTestPerformanceModelToJson(GroupTestPerformanceModel data) => json.encode(data.toJson());
//
// class GroupTestPerformanceModel {
//   GroupTestPerformanceModel({
//     this.status,
//     this.code,
//     this.message,
//     this.data,
//   });
//
//   bool? status;
//   String? code;
//   String? message;
//   List<GroupPerformanceData>? data;
//
//   factory GroupTestPerformanceModel.fromJson(Map<String, dynamic> json) => GroupTestPerformanceModel(
//     status: json["status"] == null ? null : json["status"],
//     code: json["code"] == null ? null : json["code"],
//     message: json["message"] == null ? null : json["message"],
//     data: json["data"] == null ? null : List<GroupPerformanceData>.from(json["data"].map((x) => GroupPerformanceData.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status == null ? null : status,
//     "code": code == null ? null : code,
//     "message": message == null ? null : message,
//     "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
//   };
// }
//
// class GroupPerformanceData {
//   GroupPerformanceData({
//     this.totalScore,
//     this.tests,
//     this.course,
//   });
//
//   double? totalScore;
//   dynamic tests;
//   Course? course;
//
//   factory GroupPerformanceData.fromJson(Map<String, dynamic> json) => GroupPerformanceData(
//     totalScore: json["total_score"] == null ? null : json["total_score"].toDouble(),
//     tests: json["tests"] == null ? null : json["tests"],
//     course: json["course"] == null ? null : Course.fromJson(json["course"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "total_score": totalScore == null ? null : totalScore,
//     "tests": tests == null ? null : tests,
//     "course": course == null ? null : course!.toJson(),
//   };
// }
//
// class Course {
//   Course({
//     this.id,
//     this.name,
//   });
//
//   int? id;
//   String? name;
//
//   factory Course.fromJson(Map<String, dynamic> json) => Course(
//     id: json["id"] == null ? null : json["id"],
//     name: json["name"] == null ? null : json["name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id == null ? null : id,
//     "name": name == null ? null : name,
//   };
// }

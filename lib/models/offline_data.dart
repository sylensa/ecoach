class OfflineData {
  OfflineData({
    this.id,
    this.dataId,
    this.dataType,
    this.createdAt,
    this.updatedAt,
  }) {
    if (createdAt == null) {
      createdAt = DateTime.now();
    }

    if (updatedAt == null) {
      updatedAt = DateTime.now();
    }
  }

  int? id;
  int? dataId;
  String? dataType;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory OfflineData.fromJson(Map<String, dynamic> json) => OfflineData(
        id: json["id"],
        dataId: json["data_id"],
        dataType: json["data_type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "data_id": dataId,
        "data_type": dataType,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

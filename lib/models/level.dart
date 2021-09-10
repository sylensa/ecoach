class Level {
  Level({
    this.id,
    this.name,
    this.code,
    this.group,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? code;
  String? group;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        group: json["group"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "group": group,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

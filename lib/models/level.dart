class Level {
  Level({
    this.id,
    this.name,
    this.code,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? code;
  String? category;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        category: json["category"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "category": category,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

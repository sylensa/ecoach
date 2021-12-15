class ImageFile {
  String name;
  String? base64;
  String? path;
  String? url;

  ImageFile({required this.name, this.base64, this.path, this.url});

  factory ImageFile.fromJson(Map<String, dynamic> json) =>
      ImageFile(name: json['name'], base64: json['image'], url: json['url']);
}

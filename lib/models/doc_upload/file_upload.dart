import 'dart:convert';

class FileUpload {
  String name;
  String? file;
  String? type;
  bool isFileExist;
  FileUpload({
    required this.name,
    this.type,
    this.file,
    required this.isFileExist,
  });

  factory FileUpload.fromJson(String str) =>
      FileUpload.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FileUpload.fromMap(Map<String, dynamic> json) => FileUpload(
        type: json["type"],
        file: json["file"],
        name: json["name"],
        isFileExist: json["isFileExist"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "file": file,
        "name": name,
        "isFileExist": isFileExist,
      };
}

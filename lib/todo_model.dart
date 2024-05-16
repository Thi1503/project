import 'dart:convert';

class ToDo {
  int id;
  String? imagePath;
  String? titleNode;
  String? contentNode;

  ToDo({
    required this.id,
    required this.imagePath,
    required this.titleNode,
    required this.contentNode,
  });

  factory ToDo.fromMap(Map<String, dynamic> json) => ToDo(
    id: json["id"],
    imagePath: json["imagePath"],
    titleNode: json["titleNode"],
    contentNode: json["contentNode"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "imagePath": imagePath,
    "titleNode": titleNode,
    "contentNode": contentNode,
  };


}

ToDo todoFromJson(String str) {
  final jsonData = json.decode(str);
  return ToDo.fromMap(jsonData);
}

String todoToJson(ToDo data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

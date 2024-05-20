class Label {
  int? labelId;
  int userId;
  String name;

  Label({
    this.labelId,
    required this.userId,
    required this.name,
  });

  // Convert a Label object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'label_id': labelId,
      'user_id': userId,
      'name': name,
    };
  }

  // Extract a Label object from a Map object
  factory Label.fromMap(Map<String, dynamic> map) {
    return Label(
      labelId: map['label_id'],
      userId: map['user_id'],
      name: map['name'],
    );
  }
}

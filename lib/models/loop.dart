class Loop {
  String title;

  int id;

  Loop(this.title);

  Loop.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }

  toJson() {
    return {'title': title};
  }

  Loop.fromMap(Map<String, dynamic> json) {
    title = json['title'];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }
}

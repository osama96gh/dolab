class Loop {
  String name;
  int id = 0;
  int index = 0;

  Loop(this.name);

  Loop.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  toJson() {
    return {'name': name};
  }
}

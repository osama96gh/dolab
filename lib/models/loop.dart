class Loop {
  String name;

  Loop(this.name);

  Loop.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  toJson() {
    return {'name': name};
  }
}

class Task {
  String name;
  var checkedTime = 0;

  Task(this.name, [this.checkedTime = 0]);

  Task.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        checkedTime = json['checkedTime'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'checkedTime': checkedTime,
      };
}

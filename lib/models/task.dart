import 'package:dolab/database/database_info.dart';

class Task {
  String title;
  int checkedTimes = 0;
  int id;
  int position;

  Task(this.title, this.position, [this.id, this.checkedTimes = 0]);

  Task.fromMap(Map<String, dynamic> json) {
    title = json[TaskTableInfo.columnTitle];
    checkedTimes = json[TaskTableInfo.columnCheckedTimes];
    position = json[TaskTableInfo.columnPosition];
    int id = json[TaskTableInfo.columnId];
    if (id != null) {
      this.id = id;
    }
  }

  Map<String, dynamic> toMap() => {
        TaskTableInfo.columnTitle: title,
        TaskTableInfo.columnCheckedTimes: checkedTimes,
        TaskTableInfo.columnId: id,
        TaskTableInfo.columnPosition: position
      };
}

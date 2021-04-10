import 'package:dolab/database/database_info.dart';

class Task {
  String title;
  int checkedTimes = 0;
  int id;

  Task(this.title, [this.id, this.checkedTimes = 0]);

  Task.fromMap(Map<String, dynamic> json)
      : title = json[TodoTableInfo.columnTitle],
        checkedTimes = json[TodoTableInfo.columnCheckedTimes] {
    int id = json[TodoTableInfo.columnId];
    if (id != null) {
      this.id = id;
    }
  }

  Map<String, dynamic> toMap() => {
        TodoTableInfo.columnTitle: title,
        TodoTableInfo.columnCheckedTimes: checkedTimes,
        TodoTableInfo.columnId: id
      };
}

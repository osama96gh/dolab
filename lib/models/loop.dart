import 'package:dolab/database/database_info.dart';

class Loop {
  String title;
  int checkedTaskIndex = 0;
  int id;

  Loop(this.title, {this.checkedTaskIndex=0});

  Loop.fromMap(Map<String, dynamic> json) {
    title = json[LoopTableInfo.columnTitle];
    checkedTaskIndex = json[LoopTableInfo.columnTaskIndex];
    id = json[LoopTableInfo.columnId];
  }

  Map<String, dynamic> toMap() {
    return {
      LoopTableInfo.columnTitle: title,
      LoopTableInfo.columnTaskIndex: checkedTaskIndex,
      LoopTableInfo.columnId: id
    };
  }
}

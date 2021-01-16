import 'dart:convert';

 import 'package:dolab/models/task.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoopModel with ChangeNotifier {
  var index = 0;

  final taskKey = "tasks_key";
  final indexKey = "index_key";

  List<Task> tasks = List<Task>.empty(growable: true);

  readTasksAndIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var jsonData = prefs.getString(taskKey) ?? "[]";
    _tasksFromJson(jsonData);
    index = prefs.getInt(indexKey) ?? 0;
    notifyListeners();
  }

  _tasksFromJson(String jsonData) {
    tasks.clear();
    List<dynamic> list = json.decode(jsonData);
    for (dynamic d in list) {
      tasks.add(Task.fromJson(d));
    }
  }

  _tasksToJson() {
    return jsonEncode(tasks.map((e) => e.toJson()).toList());
  }

  addTask(Task t) {
    tasks.add(t);
    storeTasks();
    notifyListeners();
  }

  storeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(indexKey, index);
  }

  storeTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(taskKey, _tasksToJson());
  }

  reorderTasks(oldPos, newPos) {
    var task = tasks.removeAt(oldPos);
    if (newPos >= tasks.length)
      tasks.add(task);
    else
      tasks.insert(newPos, task);
    notifyListeners();
    storeTasks();
  }

  deleteTask(int pos) {
    tasks.removeAt(pos);
    tasks.length == 0 ? index = 0 : index = index % tasks.length;

    storeIndex();
    storeTasks();
  }

  checkCurrentTask() {
    tasks[index].checkedTime++;
    index = (++index) % tasks.length;
    notifyListeners();
    storeIndex();
    storeTasks();
  }

  skipCurrentTask() {
    index = (++index) % tasks.length;
    notifyListeners();
    storeIndex();
  }
}

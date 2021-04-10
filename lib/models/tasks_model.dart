import 'dart:convert';

import 'package:dolab/database/task_provider.dart';
import 'package:dolab/models/loop.dart';
import 'package:dolab/models/task.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksModel with ChangeNotifier {
  Loop parentLoop;

  final indexKey = "index_key";

  TasksModel(this.parentLoop);

  var index = 0;
  List<Task> tasks = List<Task>.empty(growable: true);

  TaskProvider provider;

  readTasksAndIndex() async {
    provider = new TaskProvider();
    await provider.open();

    tasks.addAll(await provider.getTasksForSpeceficLoop(parentLoop.id));
    notifyListeners();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    // var jsonData = prefs.getString(tasksKey) ?? "[]";
    // _tasksFromJson(jsonData);
    // index = prefs.getInt(indexKey) ?? 0;
    // notifyListeners();
  }

  _tasksFromJson(String jsonData) {
    tasks.clear();
    List<dynamic> list = json.decode(jsonData);
    for (dynamic d in list) {
      tasks.add(Task.fromMap(d));
    }
  }

  _tasksToJson() {
    return jsonEncode(tasks.map((e) => e.toMap()).toList());
  }

  addTask(Task t) async {
    t= await provider.insert(t, parentLoop.id);
    tasks.add(t);
    // storeTasks();
    notifyListeners();
  }

  storeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(indexKey, index);
  }

  // storeTasks() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(loopId, _tasksToJson());
  // }

  reorderTasks(oldPos, newPos) {
    var task = tasks.removeAt(oldPos);
    if (newPos >= tasks.length)
      tasks.add(task);
    else
      tasks.insert(newPos, task);
    notifyListeners();
    // storeTasks();
  }

  deleteTask(int pos) {
    tasks.removeAt(pos);
    tasks.length == 0 ? index = 0 : index = index % tasks.length;

    storeIndex();
    // storeTasks();
  }

  checkCurrentTask() {
    tasks[index].checkedTimes++;
    provider.update(tasks[index]);
    index = (++index) % tasks.length;
    notifyListeners();
    storeIndex();
    // storeTasks();
  }

  skipCurrentTask() {
    index = (++index) % tasks.length;
    notifyListeners();
    storeIndex();
  }
}

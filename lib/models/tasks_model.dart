import 'package:dolab/database/Loop_provider.dart';
import 'package:dolab/database/task_provider.dart';
import 'package:dolab/models/loop.dart';
import 'package:dolab/models/task.dart';
import 'package:flutter/material.dart';

class TasksModel with ChangeNotifier {
  Loop parentLoop;

  TasksModel(this.parentLoop);

  List<Task> tasks = List<Task>.empty(growable: true);

  TaskProvider taskProvider = TaskProvider();
  LoopProvider loopProvider = LoopProvider();

  readTasks() async {
    await taskProvider.open();
    await loopProvider.open();
    tasks.clear();
    tasks.addAll(await taskProvider.getTasksForSpecificLoop(parentLoop.id));
    notifyListeners();
  }

  addTask(Task t) async {
    t = await taskProvider.insert(t, parentLoop.id);
    tasks.add(t);
    notifyListeners();
  }

  reorderTasks(oldPos, newPos) async {
    var isMoveDown = newPos > oldPos;
    if (isMoveDown) newPos--;
    var task = tasks.removeAt(oldPos);
    tasks.insert(newPos, task);
    notifyListeners();
    await taskProvider.rearang(task, isMoveDown, oldPos, newPos);
    readTasks();
  }

  deleteTask(int pos) async {
    // Task toDelete = tasks.removeAt(pos);
    tasks.length == 0
        ? parentLoop.checkedTaskIndex = 0
        : parentLoop.checkedTaskIndex =
            parentLoop.checkedTaskIndex % tasks.length;

    await taskProvider.delete(tasks[pos]);
    storeIndex();
    readTasks();
  }

  checkCurrentTask() {
    tasks[parentLoop.checkedTaskIndex].checkedTimes++;
    taskProvider.update(tasks[parentLoop.checkedTaskIndex]);
    parentLoop.checkedTaskIndex =
        (++parentLoop.checkedTaskIndex) % tasks.length;
    notifyListeners();
    storeIndex();
  }

  skipCurrentTask() {
    parentLoop.checkedTaskIndex =
        tasks.length == 0 ? 0 : (++parentLoop.checkedTaskIndex) % tasks.length;
    notifyListeners();
    storeIndex();
  }

  storeIndex() async {
    await loopProvider.update(parentLoop);
  }

  int getIndex() {
    return parentLoop.checkedTaskIndex;
  }
}

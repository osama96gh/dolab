import 'package:dolab/database/task_provider.dart';
import 'package:dolab/models/loop.dart';
import 'package:dolab/models/task.dart';
import 'package:flutter/material.dart';

class TasksModel with ChangeNotifier {
  Loop parentLoop;

  TasksModel(this.parentLoop);

  List<Task> tasks = List<Task>.empty(growable: true);

  TaskProvider provider;

  //TODO: use loop provider to store the changes could happen to the index in the parent loop object

  readTasks() async {
    provider = new TaskProvider();
    await provider.open();

    tasks.addAll(await provider.getTasksForSpecificLoop(parentLoop.id));
    notifyListeners();
  }

  addTask(Task t) async {
    t = await provider.insert(t, parentLoop.id);
    tasks.add(t);
    notifyListeners();
  }

  //TODO: fix the reorder function the mach the new changes
  reorderTasks(oldPos, newPos)async {
    var isMoveDown = newPos > oldPos;
    if (isMoveDown) newPos--;
    print('old ' + oldPos.toString() + " new: " + newPos.toString());

    var task = tasks.removeAt(oldPos);
    tasks.insert(newPos, task);
    notifyListeners();
    await provider.rearang(task,isMoveDown,oldPos,newPos);
  }

  //TODO: fix delete task  function
  deleteTask(int pos) async {
    Task toDelete = tasks.removeAt(pos);
    tasks.length == 0
        ? parentLoop.index = 0
        : parentLoop.index = parentLoop.index % tasks.length;
    storeIndex();
    notifyListeners();

    await provider.delete(toDelete);
  }

  checkCurrentTask() {
    tasks[parentLoop.index].checkedTimes++;
    provider.update(tasks[parentLoop.index]);
    parentLoop.index = (++parentLoop.index) % tasks.length;
    storeIndex();
    notifyListeners();
  }

  skipCurrentTask() {
    parentLoop.index =
        tasks.length == 0 ? 0 : (++parentLoop.index) % tasks.length;
    storeIndex();
    notifyListeners();
  }

  void storeIndex() {
    //TODO: implement this function
  }

  int getIndex() {
    return parentLoop.index;
  }
}

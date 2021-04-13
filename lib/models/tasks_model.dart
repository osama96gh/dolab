import 'package:dolab/database/Loop_provider.dart';
import 'package:dolab/database/task_provider.dart';
import 'package:dolab/models/loop.dart';
import 'package:dolab/models/task.dart';
import 'package:flutter/material.dart';

class TasksModel with ChangeNotifier {
  Loop parentLoop;

  TasksModel(this.parentLoop);

  List<Task> tasks = List<Task>.empty(growable: true);

  TaskProvider taskProvider;
  LoopProvider loopProvider;

  //TODO: use loop provider to store the changes could happen to the index in the parent loop object

  readTasks() async {
    taskProvider = new TaskProvider();
    await taskProvider.open();

    loopProvider = new LoopProvider();
    await loopProvider.open();

    tasks.addAll(await taskProvider.getTasksForSpecificLoop(parentLoop.id));
    notifyListeners();
  }

  addTask(Task t) async {
    t = await taskProvider.insert(t, parentLoop.id);
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
    await taskProvider.rearang(task,isMoveDown,oldPos,newPos);
  }

  //TODO: fix delete task  function
  deleteTask(int pos) async {
    Task toDelete = tasks.removeAt(pos);
    tasks.length == 0
        ? parentLoop.checkedTaskIndex = 0
        : parentLoop.checkedTaskIndex = parentLoop.checkedTaskIndex % tasks.length;
    storeIndex();
    notifyListeners();

    await taskProvider.delete(toDelete);
  }

  checkCurrentTask() {
    tasks[parentLoop.checkedTaskIndex].checkedTimes++;
    taskProvider.update(tasks[parentLoop.checkedTaskIndex]);
    parentLoop.checkedTaskIndex = (++parentLoop.checkedTaskIndex) % tasks.length;
    storeIndex();
    notifyListeners();
  }

  skipCurrentTask() {
    parentLoop.checkedTaskIndex =
        tasks.length == 0 ? 0 : (++parentLoop.checkedTaskIndex) % tasks.length;
    storeIndex();
    notifyListeners();
  }

  void storeIndex() {
    loopProvider.update(parentLoop);  }

  int getIndex() {
    return parentLoop.checkedTaskIndex;
  }
}

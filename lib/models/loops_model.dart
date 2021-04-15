import 'package:dolab/database/Loop_provider.dart';
import 'package:dolab/database/task_provider.dart';
import 'package:dolab/models/task.dart';
import 'package:flutter/cupertino.dart';

import 'loop.dart';

class LoopsModel with ChangeNotifier {
  final loopsKey = 'loops_key';

  List<Loop> loops = [];
  List<List<Task>> loopsTasks = [];
  LoopProvider loopProvider = LoopProvider();
  TaskProvider taskProvider = TaskProvider();

  readLoopsData() async {
    await loopProvider.open();
    await taskProvider.open();
    List<Loop> ls = await loopProvider.getAllLoops();
    loops.clear();
    loopsTasks.clear();
    ls.forEach((element) {
      loops.add(element);
      loopsTasks.add([]);
      getLoopTasks(element, loopsTasks.last);
    });
    notifyListeners();

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // var jsonList = preferences.getString(loopsKey) ?? '[]';
    // _loopsFromJson(jsonList);
    // notifyListeners();
  }

  Future<void> getLoopTasks(Loop loop, List<Task> loopTasks) async {
    List<Task> tasks = await taskProvider.getTasksForSpecificLoop(loop.id);
    loopTasks.addAll(tasks);
    notifyListeners();
  }

  storeLoops() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString(loopsKey, _loopsToJson());
  }

  addLoop(Loop loop) async {
    Loop l = await loopProvider.insert(loop);
    loops.add(l);
    loopsTasks.add([]);
    getLoopTasks(l, loopsTasks.last);
    notifyListeners();
  }

  deleteLoop(Loop loop) async {
    await taskProvider.deleteAllTasksOfSpecificLoop(loop.id);
    await loopProvider.delete(loop.id);
    int idx = loops.indexOf(loop);
    print(idx.toString());
    loops.removeAt(idx);
    loopsTasks.removeAt(idx);
    notifyListeners();
  }

  @override
  void dispose() {
    loopProvider.close();
  }
}

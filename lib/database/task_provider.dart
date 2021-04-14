import 'package:dolab/database/database_info.dart';
import 'package:dolab/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskProvider {
  Database db;


  Future open({String name = databaseName, version = databaseVersion}) async {
    String path = join(await getDatabasesPath(), name);
    db = await openDatabase(
      path,
      version: version,
      onCreate: onCreateDatabase,
      onUpgrade: onUpgradeDatabase,
    );
  }

  Future<Task> insert(Task todo, int parentLoopId) async {
    Map m = todo.toMap();
    m.putIfAbsent(TaskTableInfo.columnParentLoopId, () => parentLoopId);

    todo.id = await db.insert(TaskTableInfo.tableName, m);
    return todo;
  }

  Future<List<Task>> getTasksForSpecificLoop(int loopId) async {
    List<Map> maps = await db.query(TaskTableInfo.tableName,
        columns: [
          TaskTableInfo.columnId,
          TaskTableInfo.columnParentLoopId,
          TaskTableInfo.columnPosition,
          TaskTableInfo.columnTitle,
          TaskTableInfo.columnCheckedTimes
        ],
        orderBy: '''${TaskTableInfo.columnPosition} ASC''',
        where: '''${TaskTableInfo.columnParentLoopId} = ?''',
        whereArgs: [
          loopId
        ]);

    List<Task> tasks = [];
    maps.forEach((element) {
       tasks.add(Task.fromMap(element));
    });
    return tasks;
  }

  Future rearang(Task t, bool isDown, oldP, newP) {
    if (isDown) {
      return db.transaction((txn) async {
        await txn.rawUpdate(
            '''UPDATE ${TaskTableInfo.tableName} SET ${TaskTableInfo.columnPosition} = ${TaskTableInfo.columnPosition} -1 WHERE ${TaskTableInfo.columnPosition} > ? and ${TaskTableInfo.columnPosition} <= ?''',
            [oldP, newP]);

        await txn.rawUpdate(
            '''UPDATE ${TaskTableInfo.tableName} SET ${TaskTableInfo.columnPosition} = ${newP}  WHERE ${TaskTableInfo.columnId} = ? ''',
            [t.id]);
      });
    } else {
      return db.transaction((txn) async {
        await txn.rawUpdate(
            '''UPDATE ${TaskTableInfo.tableName} SET ${TaskTableInfo.columnPosition} = ${TaskTableInfo.columnPosition} +1 WHERE ${TaskTableInfo.columnPosition} < ? and ${TaskTableInfo.columnPosition} >= ?''',
            [oldP, newP]);

        await txn.rawUpdate(
            '''UPDATE ${TaskTableInfo.tableName} SET ${TaskTableInfo.columnPosition} = ${newP}  WHERE ${TaskTableInfo.columnId} = ? ''',
            [t.id]);
      });
    }
  }

  Future delete(Task k) async {
    return db.transaction((txn) async {
      await txn.rawUpdate(
          '''UPDATE ${TaskTableInfo.tableName} SET ${TaskTableInfo.columnPosition} = ${TaskTableInfo.columnPosition} -1 WHERE ${TaskTableInfo.columnPosition} > ?''',
          [k.position]);
      await txn.delete(TaskTableInfo.tableName,
          where: '''${TaskTableInfo.columnId} = ?''', whereArgs: [k.id]);
    });
  }

  Future<int> update(Task todo) async {
    return await db.update(TaskTableInfo.tableName, todo.toMap(),
        where: '${TaskTableInfo.columnId} = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}

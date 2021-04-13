import 'package:dolab/database/database_info.dart';
import 'package:dolab/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskProvider {
  Database db;

  _onCreateDatabase(Database db, int version) async {
    await db.execute(
      '''
         create table ${TodoTableInfo.tableName} ( 
          ${TodoTableInfo.columnId} integer primary key autoincrement, 
          ${TodoTableInfo.columnParentLoopId} integer not null,
          ${TodoTableInfo.columnPosition} integer not null,
          ${TodoTableInfo.columnTitle} text not null,
          ${TodoTableInfo.columnCheckedTimes} integer
          )
        ''',
    );
  }

  _onUpgradeDatabase(Database db, int oldVersion, int newVersion) async {
    _onCreateDatabase(db, newVersion);
  }

  Future open({String name = databaseName, version = databaseVersion}) async {
    String path = join(await getDatabasesPath(), name);
    db = await openDatabase(
      path,
      version: version,
      onCreate: _onCreateDatabase,
      onUpgrade: _onUpgradeDatabase,
    );
  }

  Future<Task> insert(Task todo, int parentLoopId) async {
    Map m = todo.toMap();
    m.putIfAbsent(TodoTableInfo.columnParentLoopId, () => parentLoopId);

    todo.id = await db.insert(TodoTableInfo.tableName, m);
    return todo;
  }

  Future<List<Task>> getTasksForSpecificLoop(int loopId) async {
    List<Map> maps = await db.query(TodoTableInfo.tableName,
        columns: [
          TodoTableInfo.columnId,
          TodoTableInfo.columnParentLoopId,
          TodoTableInfo.columnPosition,
          TodoTableInfo.columnTitle,
          TodoTableInfo.columnCheckedTimes
        ],
        orderBy: '''${TodoTableInfo.columnPosition} ASC''',
        where: '''${TodoTableInfo.columnParentLoopId} = ?''',
        whereArgs: [
          loopId
        ]);

    List<Task> tasks = [];
    maps.forEach((element) {
      print(element);
      tasks.add(Task.fromMap(element));
    });
    return tasks;
  }

  Future rearang(Task t, bool isDown, oldP, newP) {
    if (isDown) {
      return db.transaction((txn) async {
        await txn.rawUpdate(
            '''UPDATE ${TodoTableInfo.tableName} SET ${TodoTableInfo.columnPosition} = ${TodoTableInfo.columnPosition} -1 WHERE ${TodoTableInfo.columnPosition} > ? and ${TodoTableInfo.columnPosition} <= ?''',
            [oldP, newP]);

        await txn.rawUpdate(
            '''UPDATE ${TodoTableInfo.tableName} SET ${TodoTableInfo.columnPosition} = ${newP}  WHERE ${TodoTableInfo.columnId} = ? ''',
            [t.id]);
      });
    } else {
      return db.transaction((txn) async {
        await txn.rawUpdate(
            '''UPDATE ${TodoTableInfo.tableName} SET ${TodoTableInfo.columnPosition} = ${TodoTableInfo.columnPosition} +1 WHERE ${TodoTableInfo.columnPosition} < ? and ${TodoTableInfo.columnPosition} >= ?''',
            [oldP, newP]);

        await txn.rawUpdate(
            '''UPDATE ${TodoTableInfo.tableName} SET ${TodoTableInfo.columnPosition} = ${newP}  WHERE ${TodoTableInfo.columnId} = ? ''',
            [t.id]);
      });
    }
  }

  Future delete(Task k) async {
    return db.transaction((txn) async {
      await txn.rawUpdate(
          '''UPDATE ${TodoTableInfo.tableName} SET ${TodoTableInfo.columnPosition} = ${TodoTableInfo.columnPosition} -1 WHERE ${TodoTableInfo.columnPosition} > ?''',
          [k.position]);
      await txn.delete(TodoTableInfo.tableName,
          where: '''${TodoTableInfo.columnId} = ?''', whereArgs: [k.id]);
    });
  }

  Future<int> update(Task todo) async {
    return await db.update(TodoTableInfo.tableName, todo.toMap(),
        where: '${TodoTableInfo.columnId} = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}

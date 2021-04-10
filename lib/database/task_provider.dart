import 'package:dolab/database/database_info.dart';
import 'package:dolab/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskProvider {
  Database db;

  Future open({String name = databaseName, version = databaseVersion}) async {
    String path =  join(await getDatabasesPath(), name);
    db = await openDatabase(path, version: version,
        onCreate: (Database db, int version) async {
      await db.execute(
        '''
         create table ${TodoTableInfo.tableName} ( 
          ${TodoTableInfo.columnId} integer primary key autoincrement, 
          ${TodoTableInfo.columnParentLoopId} integer not null,
          ${TodoTableInfo.columnTitle} text not null,
          ${TodoTableInfo.columnCheckedTimes} integer
          )
        ''',
      );
    });
  }

  Future<Task> insert(Task todo, int parentLoopId) async {
    Map m = todo.toMap();
    m.putIfAbsent(TodoTableInfo.columnParentLoopId, () => parentLoopId);

    todo.id = await db.insert(TodoTableInfo.tableName, m);
    return todo;
  }

  Future<List<Task>> getTasksForSpeceficLoop(int loopId) async {
    List<Map> maps = await db.query(TodoTableInfo.tableName,
        columns: [
          TodoTableInfo.columnId,
          TodoTableInfo.columnParentLoopId,
          TodoTableInfo.columnTitle,
          TodoTableInfo.columnCheckedTimes
        ],
        where: '''${TodoTableInfo.columnParentLoopId} = ?''',
        whereArgs: [loopId]);

    List<Task> tasks = [];
    maps.forEach((element) {
      tasks.add(Task.fromMap(element));
    });
    return tasks;
  }

  Future<int> delete(int id) async {
    return await db.delete(TodoTableInfo.tableName, where: '${TodoTableInfo.columnId} = ?', whereArgs: [id]);
  }

  Future<int> update(Task todo) async {
    return await db.update(TodoTableInfo.tableName, todo.toMap(),
        where: '${TodoTableInfo.columnId} = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}

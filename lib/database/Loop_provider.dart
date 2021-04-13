import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/loop.dart';
import 'database_info.dart';

final String tableLoop = 'loop';
final String columnId = '_id';
final String columnTitle = 'title';

class LoopProvider {
  Database db;

  Future open({String name = databaseName,int version = databaseVersion}) async {
    //get database path using path library
    var dbPath = join(await getDatabasesPath(), name);
    db = await openDatabase(
      dbPath,
      version: version,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          create table $tableLoop ( 
            $columnId integer primary key autoincrement, 
            $columnTitle text not null)
          ''',
        );
      },
    );
  }

  Future<Loop> insert(Loop loop) async {
    loop.id = await db.insert(tableLoop, loop.toMap());
    return loop;
  }

  Future<Loop> getLoop(int id) async {
    List<Map> maps = await db.query(tableLoop,
        columns: [columnId, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Loop.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Loop>> getAllLoops() async {
    List<Map<String, Object>> maps = await db.query(tableLoop);
    List<Loop> loops = [];
    maps.forEach((element) {
      loops.add(Loop.fromMap(element));
    });
    return loops;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableLoop, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Loop todo) async {
    return await db.update(tableLoop, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}

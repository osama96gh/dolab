import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/loop.dart';
import 'database_info.dart';


class LoopProvider {
  Database db;

  Future open({String name = databaseName,int version = databaseVersion}) async {
    //get database path using path library
    var dbPath = join(await getDatabasesPath(), name);
    db = await openDatabase(
      dbPath,
      version: version,
      onCreate: onCreateDatabase,
      onUpgrade: onUpgradeDatabase,
    );
  }

  Future<Loop> insert(Loop loop) async {
    loop.id = await db.insert( LoopTableInfo.tableName, loop.toMap());
    return loop;
  }

  Future<Loop> getLoop(int id) async {
    List<Map> maps = await db.query(LoopTableInfo.tableName,
        columns: [LoopTableInfo.columnId, LoopTableInfo.columnTitle, LoopTableInfo.columnTaskIndex],
        where: '''${LoopTableInfo.columnId} = ?''',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Loop.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Loop>> getAllLoops() async {
    List<Map<String, Object>> maps = await db.query(LoopTableInfo.tableName);
    List<Loop> loops = [];
    maps.forEach((element) {
      loops.add(Loop.fromMap(element));
    });
    return loops;
  }

  Future<int> delete(int id) async {
    return await db.delete(LoopTableInfo.tableName, where: '''${LoopTableInfo.columnId} = ?''', whereArgs: [id]);
  }

  Future<int> update(Loop loop) async {
    return await db.update(LoopTableInfo.tableName, loop.toMap(),
        where: '''${LoopTableInfo.columnId} = ?''', whereArgs: [loop.id]);
  }

  Future close() async => db.close();
}

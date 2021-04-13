
import 'package:sqflite/sqflite.dart';



const databaseName = "dolab.db";
const int databaseVersion = 1;


onCreateDatabase(Database db, int version) async {

  await db.execute(
    '''
          create table ${LoopTableInfo.tableName} ( 
            ${LoopTableInfo.columnId}  integer primary key autoincrement, 
            ${LoopTableInfo.columnTaskIndex}  integer not null , 
            ${LoopTableInfo.columnTitle}  text not null
            )
          ''',
  );

  await db.execute(
    '''
         create table ${TaskTableInfo.tableName} ( 
          ${TaskTableInfo.columnId} integer primary key autoincrement, 
          ${TaskTableInfo.columnParentLoopId} integer not null,
          ${TaskTableInfo.columnPosition} integer not null,
          ${TaskTableInfo.columnTitle} text not null,
          ${TaskTableInfo.columnCheckedTimes} integer
          )
        ''',
  );
}

onUpgradeDatabase(Database db, int oldVersion, int newVersion) async {
  onCreateDatabase(db, newVersion);
}

class LoopTableInfo {

  static final String tableName = 'loop';
  static final String columnId = '_id';
  static final String columnTitle = 'title';
  static final String columnTaskIndex = 'task_index';
}

class TaskTableInfo {
  static final String tableName = 'task';
  static final String columnId = '_id';
  static final String columnTitle = 'title';
  static final String columnCheckedTimes = 'checked_times';
  static final String columnParentLoopId = 'loop_id';
  static final String columnPosition = 'position';
}



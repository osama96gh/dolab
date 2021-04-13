
const databaseName = "dolab.db";
const int databaseVersion = 1;

class TodoTableInfo {
  static final String tableName = 'todo';
  static final String columnId = '_id';
  static final String columnTitle = 'title';
  static final String columnCheckedTimes = 'checked_times';
  static final String columnParentLoopId = 'loop_id';
  static final String columnPosition = 'position';
}

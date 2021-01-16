import 'dart:convert';

import 'package:dolab/manege_tasks_page.dart';
import 'package:dolab/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

var index = 0;
List<Task> tasks = List<Task>.empty(growable: true);

final taskKey = "tasks_key";
final indexKey = "index_key";

class DisplayTasksPage extends StatefulWidget {
  DisplayTasksPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DisplayTasksPageState createState() {
    return _DisplayTasksPageState();
  }
}

class _DisplayTasksPageState extends State<DisplayTasksPage> {
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _readTasksAndIndex();
  }

  _addTask(Task t) {
    setState(() {
      tasks.add(t);
    });
  }

  _tasksToJson() {
    return jsonEncode(tasks.map((e) => e.toJson()).toList());
  }

  _readTasksAndIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var jsonData = prefs.getString(taskKey) ?? "[]";
      _tasksFromJson(jsonData);
      index = prefs.getInt(indexKey) ?? 0;
    });
  }

  _tasksFromJson(String jsonData) {
    tasks.clear();
    List<dynamic> list = json.decode(jsonData);
    for (dynamic d in list) {
      tasks.add(Task.fromJson(d));
    }
  }

  _storeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(indexKey, index);
  }

  _storeTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(taskKey, _tasksToJson());
  }

  onReorder(oldPos, newPos) {
    setState(() {
      var task = tasks.removeAt(oldPos);
      if (newPos >= tasks.length)
        tasks.add(task);
      else
        tasks.insert(newPos, task);
    });
    _storeTasks();
  }

  deleteTask(int pos) {
    setState(() {
      tasks.removeAt(pos);
      tasks.length == 0 ? index = 0 : index = index % tasks.length;
    });
    _storeIndex();
    _storeTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.width),
                  child: TasksListWidget(_controller),
                ),
              ),
            ),
            IconButton(
                icon: Icon(Icons.keyboard_arrow_up),
                onPressed: () {
                  setState(() {});
                }),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      EdgeInsets.only(right: 50, left: 50, top: 20, bottom: 20),
                  child: ButtonsWidget(
                    addTask: (Task t) {
                      _addTask(t);
                      _storeTasks();
                    },
                    checkCurrentTask: () {
                      setState(() {
                        tasks[index].checkedTime++;
                        index = (++index) % tasks.length;
                      });
                      _storeIndex();
                      _storeTasks();
                    },
                    skip: () {
                      setState(() {
                        index = (++index) % tasks.length;
                      });
//                    _controller.animateTo(
//                        index * MediaQuery.of(context).size.width,
//                        duration: Duration(milliseconds: 500),
//                        curve: Curves.linear);
                      _storeIndex();
                    },
                    deleteTask: deleteTask,
                    onReorder: onReorder,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TasksListWidget extends StatefulWidget {
  final _controller;

  TasksListWidget(this._controller, {Key key}) : super(key: key);

  @override
  _TasksListWidgetState createState() {
    return _TasksListWidgetState();
  }
}

class _TasksListWidgetState extends State<TasksListWidget> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget._controller.animateTo(index * MediaQuery.of(context).size.width,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
    });
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: widget._controller,
      itemBuilder: (context, i) {
        bool isCurrent = i == index;
        return Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Card(
                color: isCurrent ? Colors.blue : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                elevation: 8,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        tasks[i].name,
                        style: TextStyle(
                          color: isCurrent ? Colors.white : Colors.blueGrey,
                          fontSize: 26,
                          letterSpacing: 5,
                          wordSpacing: 5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(tasks[i].checkedTime.toString()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
      itemCount: tasks.length,
    );
  }
}

class ButtonsWidget extends StatelessWidget {
  var addTask;
  var checkCurrentTask;
  var skip;
  var deleteTask;
  var onReorder;

  ButtonsWidget(
      {this.addTask,
      this.checkCurrentTask,
      this.skip,
      this.deleteTask,
      this.onReorder});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlineButton(
                    onLongPress: () {
                      checkCurrentTask();
                    },
                    onPressed: () {
                      final snackBar = SnackBar(content: Text('Long Click!'));

                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: Icon(Icons.check),
                  ),
                ),
                SizedBox.fromSize(
                  size: Size(10, 10),
                ),
                Expanded(
                  child: OutlineButton(
                    onLongPress: () {
                      skip();
                    },
                    onPressed: () {
                      final snackBar = SnackBar(content: Text('Long Click!'));

                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: Icon(Icons.navigate_next),
                  ),
                ),
              ],
            ),
            OutlineButton.icon(
              onPressed: () {
                var bottomSheetController = showBottomSheet(
                    context: context,
                    builder: (context) => BottomSheetWidget((taskName) {
                          addTask(new Task(taskName));
                        }));
                bottomSheetController.closed.then((value) {});
              },
              icon: Icon(Icons.add),
              label: Text("Add New Task"),
            ),
            OutlineButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditTasksPage(tasks, onReorder, deleteTask)));
              },
              icon: Icon(Icons.list),
              label: Text("Manage Tasks"),
            ),
          ],
        ));
  }
}

class BottomSheetWidget extends StatefulWidget {
  final addTask;
  TextEditingController tc = TextEditingController();

  BottomSheetWidget(this.addTask);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(32), topLeft: Radius.circular(32))),
      height: 160,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 125,
                child: Column(children: [
                  DecoratedTextField(widget.tc),
                  SheetButton(widget.addTask, widget.tc)
                ]),
              ),
            )
          ]),
    );
  }
}

class DecoratedTextField extends StatelessWidget {
  TextEditingController tec;

  DecoratedTextField(this.tec);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: TextField(
          controller: tec,
          decoration: InputDecoration.collapsed(
            hintText: 'Enter task name',
          ),
        ));
  }
}

class SheetButton extends StatefulWidget {
  final addTask;
  TextEditingController tc;

  SheetButton(this.addTask, this.tc);

  _SheetButtonState createState() => _SheetButtonState();
}

class _SheetButtonState extends State<SheetButton> {
  bool checkingFlight = false;
  bool success = false;

  @override
  Widget build(BuildContext context) {
    return OutlineButton.icon(
      onPressed: () async {
        widget.addTask(widget.tc.text);
        setState(() {
          Navigator.pop(context);
        });
      },
      icon: Icon(
        Icons.check,
        color: Colors.white,
      ),
      label: Text(
        'ADD THE TASK',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

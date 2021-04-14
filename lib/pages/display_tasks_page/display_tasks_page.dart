import 'package:dolab/models/loop.dart';
import 'package:dolab/models/tasks_model.dart';
import 'package:dolab/pages/display_tasks_page/task_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'buttons.dart';

class DisplayTasksPage extends StatefulWidget {
  DisplayTasksPage({Key key, this.parentLoop}) : super(key: key);

  final Loop parentLoop;

  @override
  _DisplayTasksPageState createState() {
    return _DisplayTasksPageState();
  }
}

class _DisplayTasksPageState extends State<DisplayTasksPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TasksModel(widget.parentLoop)..readTasks(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.parentLoop.title),
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
                    child: TasksListWidget(),
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
                    padding: EdgeInsets.only(
                        right: 50, left: 50, top: 20, bottom: 20),
                    child: Consumer<TasksModel>(
                      builder: (context, model, _) => ButtonsWidget(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

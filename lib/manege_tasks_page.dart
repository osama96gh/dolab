import 'package:flutter/material.dart';

import 'Task.dart';

class EditTasksPage extends StatefulWidget {
  final List<Task> tasks;
  final Function(int oldPos, int newPos) onReorder;
  final Function(int pos) deleteTask;

  EditTasksPage(this.tasks, this.onReorder, this.deleteTask);

  @override
  _EditTasksState createState() {
    return _EditTasksState();
  }
}

class _EditTasksState extends State<EditTasksPage> {
  showDeleteDialog(BuildContext context, {@required taskIndex}) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = FlatButton(
      child: Text("Delete"),
      onPressed: () {
        setState(() {
          widget.deleteTask(taskIndex);
          Navigator.of(context).pop();
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Task:"),
      content: Text(widget.tasks[taskIndex].name),
      actions: [
        deleteButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All TASKS"),
      ),
      body: Container(
        child: ReorderableListView(
          children: [
            for (int i = 0; i < widget.tasks.length; i++)
              Container(
                key: ValueKey(widget.tasks[i]),
                margin: EdgeInsets.all(2),
                child: Card(
                  child: ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDeleteDialog(context, taskIndex: i);
                      },
                    ),
                    leading: Icon(Icons.drag_indicator),
                    title: Text(widget.tasks[i].name),
                    onTap: () {},
                  ),
                ),
              )
          ],
          onReorder: (oldP, newP) {
            // dev.log("old:"+oldP.toString()+ " new:"+newP.toString());
            // setState(() {
              widget.onReorder(oldP, newP);
            // });
          },
        ),
      ),
    );
  }
}

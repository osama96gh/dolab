import 'package:dolab/models/tasks_model.dart';
import 'package:flutter/material.dart';


class ManageTasksPage extends StatefulWidget {
  // final List<Task> tasks;
  // final Function(int oldPos, int newPos) onReorder;
  // final Function(int pos) deleteTask;
  final TasksModel model;

  ManageTasksPage(this.model);

  @override
  _EditTasksState createState() {
    return _EditTasksState();
  }
}

class _EditTasksState extends State<ManageTasksPage> {
  showDeleteDialog(BuildContext context, TasksModel model,
      {@required taskIndex}) {
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
          model.deleteTask(taskIndex);
          Navigator.of(context).pop();
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Task:"),
      content: Text(model.tasks[taskIndex].title),
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
            for (int i = 0; i < widget.model.tasks.length; i++)
              Container(
                key: ValueKey(widget.model.tasks[i]),
                margin: EdgeInsets.all(2),
                child: Card(
                  child: ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDeleteDialog(context, widget.model, taskIndex: i);
                      },
                    ),
                    leading: Icon(Icons.drag_indicator),
                    title: Text(widget.model.tasks[i].title +" "+ widget.model.tasks[i].position.toString()),
                    onTap: () {},
                  ),
                ),
              )
          ],
          onReorder: (oldP, newP) {
            // dev.log("old:"+oldP.toString()+ " new:"+newP.toString());
            setState(() {
              widget.model.reorderTasks(oldP, newP);
            });
          },
        ),
      ),
    );
  }
}

import 'package:dolab/models/task.dart';
import 'package:dolab/models/tasks_model.dart';
import 'package:dolab/pages/manage_tasks_page/manage_tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'display_tasks_page.dart';

class ButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TasksModel model = Provider.of<TasksModel>(context);

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
                      model.checkCurrentTask();
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
                      model.skipCurrentTask();
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
                          model.addTask(Task(taskName));
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
                        builder: (context) => ManageTasksPage(model)));
              },
              icon: Icon(Icons.list),
              label: Text("Manage Tasks"),
            ),
          ],
        ));
  }
}
import 'package:dolab/models/loop.dart';
import 'package:dolab/models/loops_model.dart';
import 'package:dolab/pages/add_loop_page/add_loop_page.dart';
import 'package:dolab/pages/display_tasks_page/display_tasks_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoopsPage extends StatefulWidget {
  @override
  _LoopsPageState createState() => _LoopsPageState();
}

class _LoopsPageState extends State<LoopsPage> {
  @override
  Widget build(BuildContext context) {
    showDeleteDialog(BuildContext context, LoopsModel model,
        {@required loopIndex}) {
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
          model.deleteLoop(model.loops[loopIndex]);
          Navigator.of(context).pop();
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Delete loop:"),
        content: Text(model.loops[loopIndex].title),
        actions: [
          deleteButton,
          cancelButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return ChangeNotifierProvider(
        create: (context) => LoopsModel()..readLoopsData(),
        builder: (context, __) {
          LoopsModel model = Provider.of<LoopsModel>(context);

          return Scaffold(
            appBar: AppBar(
              title: Text('DoLab'),
              centerTitle: true,
            ),
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                  Loop loop = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddLoopPage()));
                  if (loop != null) model.addLoop(loop);
                },
              ),
            ),
            body: ListView.builder(
              itemBuilder: (conx, loopIdx) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade500, width: 1),
                        borderRadius: BorderRadius.circular(8)),
                    child: ExpansionTile(
                      title: Text(
                        model.loops[loopIdx].title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      trailing: Wrap(
                        children: [
                          Text(
                            "#task: ",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            model.loopsTasks[loopIdx].isEmpty
                                ? '0'
                                : model.loopsTasks[loopIdx].length.toString(),
                            style: TextStyle(
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Text(
                          "TASKS",
                          style: TextStyle(
                            color: Colors.amber.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: model.loopsTasks[loopIdx].isEmpty
                              ? Center(child: Text('no tasks yet!'))
                              : ListView.builder(
                                  itemCount: model.loopsTasks[loopIdx].length,
                                  itemBuilder: (context, taskIdx) {
                                    return Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: taskIdx ==
                                                  model.loops[loopIdx]
                                                      .checkedTaskIndex
                                              ? Colors.amber
                                              : Colors.blue),
                                      margin: EdgeInsets.all(4),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(model
                                            .loopsTasks[loopIdx][taskIdx]
                                            .title),
                                      ),
                                    );
                                  },
                                  scrollDirection: Axis.horizontal,
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                icon: Icon(Icons.delete_rounded),
                                onPressed: () {
                                  showDeleteDialog(conx, model,
                                      loopIndex: loopIdx);

                                }),
                            IconButton(
                                icon: Icon(Icons.open_in_new_rounded),
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DisplayTasksPage(
                                                  parentLoop:
                                                      model.loops[loopIdx])));
                                  model.readLoopsData();
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: Provider.of<LoopsModel>(context).loops.length,
            ),
          );
        });
  }
}

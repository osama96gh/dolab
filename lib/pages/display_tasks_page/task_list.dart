

import 'package:dolab/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class TasksListWidget extends StatefulWidget {
  TasksListWidget({Key key}) : super(key: key);

  @override
  _TasksListWidgetState createState() {
    return _TasksListWidgetState();
  }
}

class _TasksListWidgetState extends State<TasksListWidget> {
  var _controller;

  @override
  void initState() {
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    TasksModel model = Provider.of<TasksModel>(context);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.animateTo(model.getIndex() * MediaQuery.of(context).size.width,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    });
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: _controller,
      itemBuilder: (context, i) {
        bool isCurrent = i == model.getIndex();
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
                        model.tasks[i].title,
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
                          child: Text(model.tasks[i].checkedTimes.toString()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
      itemCount: model.tasks.length,
    );
  }
}
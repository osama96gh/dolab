import 'package:dolab/models/loop.dart';
import 'package:dolab/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  var enteredText = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                onChanged: (text) {
                  setState(() {
                    enteredText = text.trim();
                  });
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.title), hintText: 'Task Name'),
              ),
              ElevatedButton(
                onPressed: enteredText.isEmpty
                    ? null
                    : () {
                  Navigator.pop(context, Task(enteredText));
                },
                child: Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

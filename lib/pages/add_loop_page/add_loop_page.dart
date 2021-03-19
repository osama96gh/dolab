import 'package:dolab/models/loop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddLoopPage extends StatefulWidget {
  @override
  _AddLoopPageState createState() => _AddLoopPageState();
}

class _AddLoopPageState extends State<AddLoopPage> {
  var enteredText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Loop'),
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
                    icon: Icon(Icons.title), hintText: 'Loop Name'),
              ),
              ElevatedButton(
                onPressed: enteredText.isEmpty
                    ? null
                    : () {
                        Navigator.pop(context, Loop(enteredText));
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

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loop.dart';

class LoopsModel with ChangeNotifier {
  final loopsKey = 'loops_key';

  List<Loop> loops = [];

  readLoopsData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var jsonList = preferences.getString(loopsKey) ?? '[]';
    _loopsFromJson(jsonList);
    notifyListeners();
  }

  _loopsFromJson(String jsonList) {
    loops.clear();
    List<dynamic> list = json.decode(jsonList);
    list.forEach((element) {
      loops.add(Loop.fromJson(element));
    });
  }

  storeLoops() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(loopsKey, _loopsToJson());
  }

  _loopsToJson() {
    return jsonEncode(loops.map((e) => e.toJson()).toList());
  }

  addLoop(Loop loop) {
    loops.add(loop);
    storeLoops();
    notifyListeners();
  }

  deleteLoop(Loop loop) {
    loops.remove(loop);
    notifyListeners();
  }
}

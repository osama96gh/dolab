import 'dart:convert';

import 'package:dolab/database/Loop_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loop.dart';

class LoopsModel with ChangeNotifier {
  final loopsKey = 'loops_key';

  List<Loop> loops = [];
  LoopProvider provider;

  readLoopsData() async {
    provider = LoopProvider();
    await provider.open();
    List<Loop> ls = await provider.getAllLoops();
    ls.forEach((element) {loops.add(element);});
    notifyListeners();

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // var jsonList = preferences.getString(loopsKey) ?? '[]';
    // _loopsFromJson(jsonList);
    // notifyListeners();


  }


  storeLoops() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString(loopsKey, _loopsToJson());
  }


  addLoop(Loop loop) async {
    loops.add(await provider.insert(loop));

    // storeLoops();
    notifyListeners();
  }

  deleteLoop(Loop loop) async {
    await provider.delete(loop.id);
    loops.remove(loop);

    notifyListeners();
  }

  @override
  void dispose() {
    provider.close();
  }


}

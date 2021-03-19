import 'package:dolab/models/loop.dart';
import 'package:dolab/models/loops_model.dart';
import 'package:dolab/pages/add_loop_page/add_loop_page.dart';
import 'package:dolab/pages/display_tasks_page/display_tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class loopsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  // var bottomSheetController = showBottomSheet(
                  //     context: context,
                  //     builder: (context) => BottomSheetWidget((loopName) {
                  //           model.addLoop(Loop(loopName));
                  //         }));
                  // bottomSheetController.closed.then((value) {});
                  Loop loop = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddLoopPage()));
                  if (loop != null) model.addLoop(loop);
                },
              ),
            ),
            body: ListView.builder(
              itemBuilder: (context, idx) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DisplayTasksPage(
                                    title: model.loops[idx].name)));
                      },
                      title: Text(model.loops[idx].name),
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

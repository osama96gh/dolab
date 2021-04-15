import 'package:flutter/material.dart';

class EmptyLoopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.all_inclusive_rounded,size: 100,color: Colors.amber,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('There is no loop yet!',
                style: TextStyle(color: Colors.amber,fontSize: 16,fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Loop can hold set of tasks that seem to be routine or repeat',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue,fontSize: 20),
            ),


          ),

          Column(
mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

             Text(
              'Like:',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black,fontSize: 16,),
            ),
              Text(
              'recipe to cook , relative to visit ,ets...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.amber,fontSize: 18,fontStyle: FontStyle.italic),
            ),
          ],),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                Text(
                  'Click the add button below to add new one',

                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12,color: Colors.grey),
                ),
              ],
            ),

          ),

        ],
      ),
    );
  }
}

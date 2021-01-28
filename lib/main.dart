import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;

mongo_dart.Db dbConnector = mongo_dart.Db('mongodb://192.168.1.107/todo');
// mongo_dart.Db dbConnector = mongo_dart.Db('mongodb://localhost:27017/todo');
mongo_dart.DbCollection coll = dbConnector.collection('todo');


var todoList;

void main() async  {
  await dbConnector.open();
  todoList = await coll.find().toList();
  print('TO DO LIST MAIN ASYNC$todoList');
  runApp(TodoPage());
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: Text('ToDo List'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh),
              onPressed: () async {
              print('Click on Refresh');
                var temp = await coll.find().toList();
                setState(() {
                  todoList = temp;
                });
              },)
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              print('Click on FloatingActionButton');

              if (textController.text != '' &&
                  textController.text != ' ' &&
                  textController.text != null) {
                coll.insert(
                    {'title': textController.text, 'isDone': false});

                textController.clear();
                var temp = await coll.find().toList();
                setState(() {
                  todoList = temp;
                });
              }
            }, 
            child: Icon(Icons.add),backgroundColor: Colors.redAccent),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(20),
                child: TextField(
                  style: TextStyle(color: Theme.of(context).textTheme.body1.color),
                  controller: textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter the Todo',
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),child: cardListBuilder()))
          ],
        ),
      ),
    );
  }

  Widget cardListBuilder() {
    return SizedBox(
      height: 1000,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int position) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Card(
              color: Colors.lightBlueAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Checkbox(
                    value: true,
                    checkColor: Colors.black,
                     activeColor: Colors.white,
                    onChanged:(bool newValue) {},
                  ),
                  Text(
                    'ffff',
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () { },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

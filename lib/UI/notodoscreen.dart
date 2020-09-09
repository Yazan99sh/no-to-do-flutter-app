import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notodo_app/model/DataHelper.dart';
import 'package:notodo_app/model/Item.dart';

class NotToDoScreen extends StatefulWidget {
  @override
  _NotToDoScreenState createState() => _NotToDoScreenState();
}

class _NotToDoScreenState extends State<NotToDoScreen> {
  var _name = new TextEditingController();
  var _name2 = new TextEditingController();
  var db = new DatabaseHelper();
  final List<Item> _listItems = <Item>[];

  @override
  void initState() {
    super.initState();
    _readAllItem();
  }

  void _submit(String text) async {
    if (_name.text.isEmpty) {
    } else {
      _name.clear();
      WidgetsFlutterBinding.ensureInitialized();
      Item item = new Item('$text', "${dateFormatter()}");
      int savedItem = await db.saveItem(item);
      Item addedItem = await db.getItem(savedItem);
      print("$addedItem");
      setState(() {
        _listItems.insert(0, addedItem);
      });
      //print("Saved Item ID : $savedItem");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("No To Do App"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        backgroundColor: Colors.white10,
      ),
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: false,
              padding: EdgeInsets.all(8.0),
              itemCount: _listItems.length,
              itemBuilder: (_, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  color: Colors.white10,
                  child: ListTile(
                    title: _listItems[index],
                    onLongPress: () {
                      _updatIt(_listItems[index], index);
                    },
                    trailing: Listener(
                      key: Key(_listItems[index].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red[900],
                      ),
                      onPointerDown: (PointerEvent) {
                        _DeletitemFromdb(_listItems[index].id, index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add item",
        backgroundColor: Colors.red[900],
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _showFormDialog();
        },
      ),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.red[900],
              controller: _name,
              autofocus: true,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.add,
                  color: Colors.red[900],
                ),
                hintText: 'eg.being gay',
                hintStyle: TextStyle(color: Colors.black),
                labelText: "Item name",
                labelStyle: TextStyle(color: Colors.red[900]),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[900]),
                ),
                counterStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _submit(_name.text.toString());
            _name.clear();
            Navigator.pop(context);
          },
          child: Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          color: Colors.red[900],
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancle",
            style: TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          color: Colors.red,
        )
      ],
      backgroundColor: Colors.white10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _readAllItem() async {
    List items = await db.getItems();
    items.forEach((item) {
      Item Iitem = Item.fromMap(item);
      print(Iitem.itemName);
      setState(() {
        _listItems.add(Item.map(item));
      });
    });
  }

  void _DeletitemFromdb(int id, int index) async {
    await db.deleteItem(id);
    setState(() {
      _listItems.removeAt(index);
    });
  }



  String dateFormatter() {
    var now =DateTime.now();
    var formatter =new DateFormat("EEE,MMM d,'yy");
    String formated =formatter.format(now);
    return formated;
  }

  void _SubmitUpdate(int index, Item item) {
    setState(() {
      _listItems.removeWhere((element){
        return _listItems[index].itemName==item.itemName;
      });
    });
  }

  void _updatIt(Item listItem, int index) {
      var alert = new AlertDialog(
        content: new Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.red[900],
                controller: _name2,
                autofocus: true,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.update,
                    color: Colors.red[900],
                  ),
                  hintText: 'eg.being gay',
                  hintStyle: TextStyle(color: Colors.black),
                  labelText: "Item name",
                  labelStyle: TextStyle(color: Colors.red[900]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[900]),
                  ),
                  counterStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              var newItem = Item.fromMap({
                "itemName": _name2.text,
                "itemDate": dateFormatter(),
                "id": listItem.id
              });
              print("hellloooo${newItem.id}");
              _SubmitUpdate(index,listItem);
              await db.updateItem(newItem);
              setState(() {
                _readAllItem();
              });
              _name2.clear();
              Navigator.pop(context);
            },
            child: Text(
              "Update",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: Colors.red[900],
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancle",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: Colors.red,
          )
        ],
        backgroundColor: Colors.white10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );
      showDialog(
          context: context,
          builder: (_) {
            return alert;
          });

  }
}

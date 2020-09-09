import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Item extends StatelessWidget {
  String _itemName;
  String _itemDate;
  int _id;

  Item(this._itemName,this._itemDate);

  Item.map(dynamic obj) {
    this._id = obj['id'];
    this._itemName = obj["itemName"];
    this._itemDate = obj["itemDate"];
  }

  String get itemName => _itemName;

  String get itemDate => _itemDate;

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["itemName"] = _itemName;
    map["itemDate"] = _itemDate;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Item.fromMap(Map<String, dynamic> map) {
    this._itemName = map["itemName"];
    this._itemDate = map["itemDate"];
    this._id = map['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
       //color: Colors.white10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _itemName,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(
                  "Created on : $_itemDate",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'UI/notodoscreen.dart';
import 'model/DataHelper.dart';
import 'model/Item.dart';

void main() async{
  runApp(MaterialApp(
    theme: ThemeData(
      splashColor: Colors.black,
    ),
    title:"No To Do App",
    home:NotToDoScreen(),
  ));
}

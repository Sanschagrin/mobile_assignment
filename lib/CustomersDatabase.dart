import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:floor/floor.dart';
import 'CustomerRecord.dart';
import 'CustomersDAO.dart';

part 'CustomersDatabase.g.dart'; // the generated code will be there

@Database(version:1, entities: [CustomerRecord])
abstract class CustomersDatabase extends FloorDatabase{

  //get interface to database
  CustomersDAO get getDao; //variable declaration for giving you access to insert, delete, update, query

}

import 'ReservationList.dart';
import 'Reservations.dart';
import 'ReservationsDAO.dart';
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'ReservationDatabase.g.dart';

@Database(version: 2, entities: [ReservationList])
abstract class ReservationDatabase extends FloorDatabase{

  ReservationsDAO get getDao;

}
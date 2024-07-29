
import 'CustomerRecord.dart';
import 'CustomersDAO.dart';
import 'ReservationList.dart';
import 'Reservations.dart';
import 'ReservationsDAO.dart';
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'ReservationDatabase.g.dart';

final migration1to2 = Migration(1, 2, (database) async {
  await database.execute(
    'CREATE TABLE IF NOT EXISTS CustomerRecord (id INTEGER PRIMARY KEY, firstName TEXT, lastName TEXT, address TEXT, postalCode TEXT,'
        'city TEXT, country TEXT, birthday TEXT)',
  );
});

@Database(version: 3, entities: [ReservationList, CustomerRecord])
abstract class ReservationDatabase extends FloorDatabase{

  ReservationsDAO get getDao;
  //CustomersDAO get customerDAO;

}
final database = $FloorReservationDatabase
    .databaseBuilder('reservationDB')
.addMigrations([migration1to2])
    .build();
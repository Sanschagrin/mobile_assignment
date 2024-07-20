import 'ReservationList.dart';
import 'package:floor/floor.dart';

import 'Reservations.dart';

@dao
abstract class ReservationsDAO{
  //database method for insterting into the database
  @insert
  Future<void>insertItem(ReservationList item);
  //database method for deleting from the database
  @delete
  Future<int>deleteItem(ReservationList item);

  //database method for getting a list of objects from the database
  @Query('Select * FROM ReservationList')
  Future<List< ReservationList >> getAll();
  //method for updating database objects
  @update
  Future<int> updateList(ReservationList item);
  //select an object where the name or flight match the user input @param search.
  @Query('Select * FROM ReservationList WHERE firstName LIKE :search OR lastName LIKE :search OR flight LIKE :search')
  Future<List< ReservationList >> searchSql(String search);
}
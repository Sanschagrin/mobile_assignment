
import 'package:floor/floor.dart';
@entity
class ReservationList {

  static int ID = 1;

  @primaryKey
  final int id;

  final String flight;

  final String firstName;

  final String lastName;

  final String destination;

  final String departure;

  final String takeOff;

  final String arrival;

  final String date;



  ReservationList(this.id, this.flight, this.firstName, this.lastName, this.destination,
      this.departure, this.takeOff, this.arrival, this.date){
    if(id>ID) ID = id + 1;
  }

  @override
  String toString(){
    return 'Flight: $flight, First Name: $firstName, Last Name: $lastName,';
  }
}
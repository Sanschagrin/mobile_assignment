import 'package:floor/floor.dart';

@entity //variable names will be the column names
class CustomerRecord{
  static int ID = 1;

  @primaryKey
  final int id;

  final String firstName;
  final String lastName;
  final String address;
  final String postalCode;
  final String city;
  final String country;
  final String birthday;


  CustomerRecord(this.id, this.firstName, this.lastName, this.address,
      this.postalCode, this.city, this.country, this.birthday){
    if(id >= ID)
      ID = id+1; //ID will always be greater than biggest db id
  }
}
import 'package:floor/floor.dart';

/// Represents a customer record in the database.
///
/// The [CustomerRecord] class is an entity that maps to a table in the database.
/// It contains fields for storing customer details and an auto-incrementing
/// primary key to uniquely identify each record.
@entity // Annotation to mark this class as a database entity
class CustomerRecord{
  /// A static variable to track the next ID value.
  ///
  /// This variable ensures that the ID for new customer records is always greater
  /// than the highest existing ID in the database.
  static int ID = 1;

  /// The unique identifier for this customer record.
  ///
  /// This field serves as the primary key in the database and is used to uniquely
  /// identify each customer record.
  @primaryKey
  final int id;

  final String firstName;
  final String lastName;
  final String address;
  final String postalCode;
  final String city;
  final String country;
  final String birthday;

  /// Creates a new [CustomerRecord] instance.
  ///
  /// The [id] parameter must be unique for each customer record. If the provided
  /// ID is greater than or equal to the current maximum ID, the static [ID] value
  /// is updated to ensure future records have a unique ID.
  ///
  /// The remaining parameters provide the customer's personal information.
  CustomerRecord(this.id, this.firstName, this.lastName, this.address,
      this.postalCode, this.city, this.country, this.birthday){
    if(id >= ID)
      ID = id+1; //ID will always be greater than biggest db id
  }
}
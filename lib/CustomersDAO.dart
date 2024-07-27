import 'package:floor/floor.dart';
import 'CustomerRecord.dart';

@dao //floor to generate the bodies
abstract class CustomersDAO{ //no function body

  @insert //make it an insert function to generate
  Future<void> insertItem(CustomerRecord itm); //asynchronous, return a future

  @delete //generate the deletion statement
  Future<int> deleteItem(CustomerRecord itm);

  @Query('Select * from ToDoItem')
  Future<List<CustomerRecord>> getAllItems();

  @update
  Future<int> updateItem(CustomerRecord itm);
}
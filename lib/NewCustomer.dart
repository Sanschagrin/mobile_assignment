import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomerRecord.dart';
import 'CustomersDAO.dart';
import 'ReservationDatabase.dart';
import 'CustomersDatabase.dart';

class NewCustomer extends StatefulWidget {
@override
  State<NewCustomer> createState() => NewCustomerState();
}

class NewCustomerState extends State<NewCustomer> {
  void buttonClicked() {
    addCustomer; //saveability
  }
  //fields:
    //firstName
    //lastName
    //address
    //postal code
    //city
    //country
    //birthday
  late TextEditingController _controller_Fname;
  late TextEditingController _controller_Lname;
  late TextEditingController _controller_address;
  late TextEditingController _controller_postalCode;
  late TextEditingController _controller_city;
  late TextEditingController _controller_country;
  late TextEditingController _controller_birthday;
  late CustomersDAO myDAO;
  var customer = <CustomerRecord> [];
  late EncryptedSharedPreferences _encryptedPrefs;


  @override
  void initState() {
    super.initState();
    _encryptedPrefs = EncryptedSharedPreferences();
    //opens the connection to the db, reads db
    $FloorCustomersDatabase.databaseBuilder('app_database.db').build().then( (database) async{
      myDAO = database.getDao;
      //now that database is loaded, and we have an interface for the db, we can query
      myDAO.getAllRecords().then((listOfItems){
        setState((){
          customer.addAll(listOfItems);//add all items from listOfItems into words (from one array to another)
        });
      });
    });
    _controller_Fname = TextEditingController();
    _controller_Lname = TextEditingController();
    _controller_address = TextEditingController();
    _controller_postalCode = TextEditingController();
    _controller_city = TextEditingController();
    _controller_country = TextEditingController();
    _controller_birthday = TextEditingController();
  }

  @override
  void dispose() {
    _controller_Fname.dispose();
    _controller_Lname.dispose();
    _controller_address.dispose();
    _controller_postalCode.dispose();
    _controller_city.dispose();
    _controller_country.dispose();
    _controller_birthday.dispose();
    super.dispose();
  }

  void loadCustomers() async {
    final customers = await myDAO.getAllRecords();
    setState(() {
      customer = customers;
    });
  }

  Future<void> addCustomer() async {
    //if all fields are full, then add customer record to list
    if (_controller_Fname.text.isNotEmpty && _controller_Lname.text.isNotEmpty && _controller_address.text.isNotEmpty &&
    _controller_postalCode.text.isNotEmpty && _controller_postalCode.text.isNotEmpty && _controller_city.text.isNotEmpty &&
    _controller_country.text.isNotEmpty && _controller_birthday.text.isNotEmpty){
      var newCustomer = CustomerRecord(
        CustomerRecord.ID++,
        _controller_Fname.text,
        _controller_Lname.text,
        _controller_address.text,
        _controller_postalCode.text,
        _controller_city.text,
        _controller_country.text,
        _controller_birthday.text
      );

      await myDAO.insertItem(newCustomer); // Insert customer into database
      setState(() {
        customer.add(newCustomer);
      });
      Navigator.pop(context);
    }
    else
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please ensure all fields are filled'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Oki doki')
          )
              ]
          );
        }
      );

  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text ("Add new customer:"),
          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text ("Please fill out the following fields:"),

                  //text field for first name
                  TextField(
                    key: ValueKey("firstName"),
                    controller: _controller_Fname,
                    decoration: InputDecoration(
                      hintText:'Type here',
                      border: OutlineInputBorder(),
                      labelText: "First name"
                    )
                  ),

                  //text field for last name
                  TextField(controller: _controller_Lname,
                      key: ValueKey("lastName"),
                      decoration: InputDecoration(
                          hintText:'Type here',
                          border: OutlineInputBorder(),
                          labelText: "Last name"
                      )
                  ),

                  //text field for address
                  TextField(controller: _controller_address,
                      key: ValueKey("address"),
                      decoration: InputDecoration(
                          hintText:'Type here',
                          border: OutlineInputBorder(),
                          labelText: "Address"
                      )
                  ),

                  //text field for postal code
                  //add verification for format
                  TextField(controller: _controller_postalCode,
                      key: ValueKey("postalCode"),
                      decoration: InputDecoration(
                          hintText:'Type here',
                          border: OutlineInputBorder(),
                          labelText: "Postal code"
                      )
                  ),

                  //text field for city
                  TextField(controller: _controller_city,
                      key: ValueKey("city"),
                      decoration: InputDecoration(
                          hintText:'Type here',
                          border: OutlineInputBorder(),
                          labelText: "City"
                      )
                  ),

                  //text field for country
                  //make drop down?
                  TextField(controller: _controller_country,
                      key: ValueKey("country"),
                      decoration: InputDecoration(
                          hintText:'Type here',
                          border: OutlineInputBorder(),
                          labelText: "Country"
                      )
                  ),

                  //text field for birthday
                  //add date selector?
                  TextField(controller: _controller_birthday,
                      key: ValueKey("birthday"),
                      decoration: InputDecoration(
                          hintText:'Type here',
                          border: OutlineInputBorder(),
                          labelText: "birthday"
                      )
                  ),

                  //button
                  ElevatedButton(
                      onPressed:buttonClicked,
                      child: Text ("Click here")
                  ),


                ],
              ),
            ),
          ]
        )
      )
    );
  }
}
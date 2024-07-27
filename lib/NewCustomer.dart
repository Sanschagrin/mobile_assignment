import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewCustomer extends StatefulWidget {
@override
  State<NewCustomer> createState() => NewCustomerState();
}



class NewCustomerState extends State<NewCustomer> {
  void buttonClicked() {
    return ; //add saveability
  }
  //fields:
    //firstName
    //lastName
    //address
    //postal code
    //city
    //country
    //birthday
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _address;
  late TextEditingController _postalCode;
  late TextEditingController _city;
  late TextEditingController _country;
  late TextEditingController _birthday;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _address = TextEditingController();
    _postalCode = TextEditingController();
    _city = TextEditingController();
    _country = TextEditingController();
    _birthday = TextEditingController();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _address.dispose();
    _postalCode.dispose();
    _city.dispose();
    _country.dispose();
    _birthday.dispose();
    super.dispose();
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
                    controller: _firstName,
                    decoration: InputDecoration(
                      hintText:'Type here',
                      border: OutlineInputBorder(),
                      labelText: "First name"
                    )
                  ),

                  //text field for last name
                  TextField(controller: _lastName,
                      key: ValueKey("lastName"),
                      decoration: InputDecoration(
                          hintText:'Type here',
                          border: OutlineInputBorder(),
                          labelText: "Last name"
                      )
                  ),

                  //text field for address
                  TextField(controller: _address,
                      key: ValueKey("address"),
                      decoration: InputDecoration(
                          hintText:'Type here',
                          border: OutlineInputBorder(),
                          labelText: "Address"
                      )
                  ),

                  //text field for postal code
                  //add verification for format
                  TextField(controller: _postalCode,
                      key: ValueKey("postalCode"),
                      decoration: InputDecoration(
                          hintText:'Type here',
                          border: OutlineInputBorder(),
                          labelText: "Postal code"
                      )
                  ),

                  //text field for city
                  TextField(controller: _city,
                      key: ValueKey("city"),
                      decoration: InputDecoration(
                          hintText:'Type here',
                          border: OutlineInputBorder(),
                          labelText: "City"
                      )
                  ),

                  //text field for country
                  //make drop down?
                  TextField(controller: _country,
                      key: ValueKey("country"),
                      decoration: InputDecoration(
                          hintText:'Type here',
                          border: OutlineInputBorder(),
                          labelText: "Country"
                      )
                  ),

                  //text field for birthday
                  //add date selector?
                  TextField(controller: _birthday,
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
                      child: Text ("Touch me >O<")
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
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomerRecord.dart';
import 'CustomersDAO.dart';
import 'CustomersDatabase.dart';
import 'AppLocalizations.dart';

/// A widget that allows for the addition of a new customer or updating an existing customer.
///
/// This widget provides text fields for entering customer details and options to add or update the customer record.
class NewCustomer extends StatefulWidget {
  /// Creates a [NewCustomer] widget.
  ///
  /// The [customer] parameter is optional and can be used to initialize the widget
  /// with an existing customer record.
  final CustomerRecord? customer;

  NewCustomer({this.customer});

  @override
  State<NewCustomer> createState() => NewCustomerState();
}

class NewCustomerState extends State<NewCustomer> {
  // Text controllers for the form fields
  late TextEditingController _controller_Fname;
  late TextEditingController _controller_Lname;
  late TextEditingController _controller_address;
  late TextEditingController _controller_postalCode;
  late TextEditingController _controller_city;
  late TextEditingController _controller_country;
  late TextEditingController _controller_birthday;

  // Data access object for interacting with the database
  late CustomersDAO myDAO;

  // List of customer records fetched from the database
  var customer = <CustomerRecord>[];

  // Encrypted shared preferences for securely storing customer data
  late EncryptedSharedPreferences _encryptedPrefs;

  @override
  void initState() {
    super.initState();
    _encryptedPrefs = EncryptedSharedPreferences();
    // Opens the connection to the db, reads db
    $FloorCustomersDatabase.databaseBuilder('app_database.db').build().then((database) async {
      myDAO = database.getDao;
      // Now that database is loaded, and we have an interface for the db, we can query
      myDAO.getAllRecords().then((listOfItems) {
        setState(() {
          customer.addAll(listOfItems); // Add all items from listOfItems into words (from one array to another)
        });
      });
    });
    // Initialize text controllers with existing customer data if available
    _controller_Fname = TextEditingController(text: widget.customer?.firstName ?? '');
    _controller_Lname = TextEditingController(text: widget.customer?.lastName ?? '');
    _controller_address = TextEditingController(text: widget.customer?.address ?? '');
    _controller_postalCode = TextEditingController(text: widget.customer?.postalCode ?? '');
    _controller_city = TextEditingController(text: widget.customer?.city ?? '');
    _controller_country = TextEditingController(text: widget.customer?.country ?? '');
    _controller_birthday = TextEditingController(text: widget.customer?.birthday ?? '');
  }

  @override
  void dispose() {
    // Dispose of the text controllers when the widget is disposed
    _controller_Fname.dispose();
    _controller_Lname.dispose();
    _controller_address.dispose();
    _controller_postalCode.dispose();
    _controller_city.dispose();
    _controller_country.dispose();
    _controller_birthday.dispose();
    super.dispose();
  }

  /// Adds a new customer to the database or updates an existing customer record.
  ///
  /// If all fields are filled, the customer record will be added or updated in the database.
  /// If any field is empty, an error dialog will be shown.
  Future<void> addCustomer() async {
    // If all fields are full, then add customer record to list
    if (_controller_Fname.text.isNotEmpty &&
        _controller_Lname.text.isNotEmpty &&
        _controller_address.text.isNotEmpty &&
        _controller_postalCode.text.isNotEmpty &&
        _controller_city.text.isNotEmpty &&
        _controller_country.text.isNotEmpty &&
        _controller_birthday.text.isNotEmpty) {
      var newCustomer = CustomerRecord(
        CustomerRecord.ID++,
        _controller_Fname.text,
        _controller_Lname.text,
        _controller_address.text,
        _controller_postalCode.text,
        _controller_city.text,
        _controller_country.text,
        _controller_birthday.text,
      );

      if (widget.customer == null) {
        await myDAO.insertItem(newCustomer); // Insert customer into database
        setState(() {
          customer.add(newCustomer);
        });
      } else {
        await myDAO.updateItem(newCustomer); // Update customer in database
        setState(() {
          // Update local list if needed
        });
      }
      saveSharedPrefs();
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)?.translate('error') ?? 'Error'),
            content: Text(AppLocalizations.of(context)?.translate('fill_all') ?? 'Please ensure all fields are filled'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }

  /// Saves the values from the text controllers to encrypted shared preferences.
  ///
  /// The values include first name, last name, address, postal code, city, country, and birthday.
  void saveSharedPrefs() async {
    await _encryptedPrefs.setString('fname', _controller_Fname.text);
    await _encryptedPrefs.setString('lname', _controller_Lname.text);
    await _encryptedPrefs.setString('address', _controller_address.text);
    await _encryptedPrefs.setString('postalCode', _controller_postalCode.text);
    await _encryptedPrefs.setString('city', _controller_city.text);
    await _encryptedPrefs.setString('country', _controller_country.text);
    await _encryptedPrefs.setString('birthday', _controller_birthday.text);
  }

  /// Loads the values from encrypted shared preferences into the text controllers.
  ///
  /// The values include first name, last name, address, postal code, city, country, and birthday.
  void loadSharedPrefs() async {
    String? fname = await _encryptedPrefs.getString('fname') ?? '';
    String? lname = await _encryptedPrefs.getString('lname') ?? '';
    String? address = await _encryptedPrefs.getString('address') ?? '';
    String? postalCode = await _encryptedPrefs.getString('postalCode') ?? '';
    String? city = await _encryptedPrefs.getString('city') ?? '';
    String? country = await _encryptedPrefs.getString('country') ?? '';
    String? birthday = await _encryptedPrefs.getString('birthday') ?? '';
    setState(() {
      _controller_Fname.text = fname;
      _controller_Lname.text = lname;
      _controller_address.text = address;
      _controller_postalCode.text = postalCode;
      _controller_city.text = city;
      _controller_country.text = country;
      _controller_birthday.text = birthday;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [IconButton(
          icon: const Icon(Icons.help),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)?.translate('instructions') ?? 'Instructions'),
                  content: Text(AppLocalizations.of(context)?.translate('new_cust_instruct') ?? "new cust"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    )
                  ],
                );
              },
            );
          },
        ),
        ],

        title: Text(AppLocalizations.of(context)?.translate('add_new_customer') ?? "Add new customer:"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                      AppLocalizations.of(context)?.translate('fill_fields') ?? "Please fill out the following fields:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                  SizedBox(height: 20),
                  // Text field for first name
                  TextField(
                    key: ValueKey("firstName"),
                    controller: _controller_Fname,
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)?.translate('first_name') ?? "First name",
                    ),
                  ),
                  SizedBox(height: 16),

                  // Text field for last name
                  TextField(
                    controller: _controller_Lname,
                    key: ValueKey("lastName"),
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)?.translate('last_name') ?? "Last name",
                    ),
                  ),
                  SizedBox(height: 16),

                  // Text field for address
                  TextField(
                    controller: _controller_address,
                    key: ValueKey("address"),
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)?.translate('address') ??"Address",
                    ),
                  ),
                  SizedBox(height: 16),

                  // Text field for postal code
                  // Add verification for format
                  TextField(
                    controller: _controller_postalCode,
                    key: ValueKey("postalCode"),
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)?.translate('postal') ??"Postal code",
                    ),
                  ),
                  SizedBox(height: 16),

                  // Text field for city
                  TextField(
                    controller: _controller_city,
                    key: ValueKey("city"),
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)?.translate('city') ?? "City",
                    ),
                  ),
                  SizedBox(height: 16),

                  // Text field for country
                  // Make drop down?
                  TextField(
                    controller: _controller_country,
                    key: ValueKey("country"),
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)?.translate('country') ?? "Country",
                    ),
                  ),
                  SizedBox(height: 16),

                  // Text field for birthday
                  // Add date selector?
                  TextField(
                    controller: _controller_birthday,
                    key: ValueKey("birthday"),
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)?.translate('birthdate') ?? "Birthdate",
                    ),
                  ),
                  SizedBox(height: 16),

                  // Buttons for adding a customer and loading shared preferences
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: addCustomer,
                        child: Text(AppLocalizations.of(context)?.translate('add') ??"Add Customer"),
                      ),
                      SizedBox(width: 20), // Space between buttons
                      ElevatedButton(
                        onPressed: loadSharedPrefs,
                        child: Text(AppLocalizations.of(context)?.translate('load_cust') ?? "Load Last Customer Info"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

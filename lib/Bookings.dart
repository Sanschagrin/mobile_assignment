import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'AppLocalizations.dart';
import 'ReservationList.dart';
import 'ReservationsDAO.dart';
import 'ReservationDatabase.dart';
/*
 *Gregory Mah 041114855
 *This class is the bookings class, it will create brand new bookings with completely new values. It features
 * text field values for each of the bookings so that each column can be populated. If data isnt filled out
 * an alert dialog will popup asking for correct inputs.
 */
class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  var reserved = <ReservationList>[]; /// List to hold reservations added in this session.
  late TextEditingController _controllerFlight;  /// Controller for the flight name text field.
  late TextEditingController _controllerFname;  /// Controller for the first name text field.
  late TextEditingController _controllerLname;  /// Controller for the last name text field.
  late TextEditingController _controllerDepart;  /// Controller for the departure city text field.
  late TextEditingController _controllerDest;  /// Controller for the destination city text field.
  late TextEditingController _controllerTakeOff;  /// Controller for the departure time text field.
  late TextEditingController _controllerArrival;  /// Controller for the arrival time text field.
  late TextEditingController _controllerDate;  /// Controller for the date text field.
  late ReservationsDAO myDao;  /// Data Access Object for interacting with the reservations database.
  late EncryptedSharedPreferences _encryptedPrefs;  /// EncryptedSharedPreferences instance for secure data storage.

  @override
  void initState() {
    super.initState();

    _encryptedPrefs = EncryptedSharedPreferences();

    $FloorReservationDatabase.databaseBuilder('app_database.db').build().then((database) {
      myDao = database.getDao;
      myDao.getAll().then((listOfItems) {
        setState(() {
          reserved.addAll(listOfItems);
          loadReservations();
        });
      });
    });

    _controllerFlight = TextEditingController();
    _controllerFname = TextEditingController();
    _controllerLname = TextEditingController();
    _controllerDepart = TextEditingController();
    _controllerDest = TextEditingController();
    _controllerTakeOff = TextEditingController();
    _controllerArrival = TextEditingController();
    _controllerDate = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerFlight.dispose();
    _controllerFname.dispose();
    _controllerLname.dispose();
    _controllerDepart.dispose();
    _controllerDest.dispose();
    _controllerTakeOff.dispose();
    _controllerArrival.dispose();
    _controllerDate.dispose();
  }
/*
 *Loads the reservations from the database using the myDao.getAll() method to be used to populate the listview
 */
  void loadReservations() async {
    final reservations = await myDao.getAll();
    setState(() {
      reserved = reservations;
    });
  }
/*
 * Adds the reservation to the database by distinguishing the values in the text fields form
 * to their corresponding database columns. It displays a snack bar on success and an alert dialog on invalid data
 * entry.
 */
  void addItem() {
    if (_controllerFlight.text.isNotEmpty && _controllerFname.text.isNotEmpty && _controllerLname.text.isNotEmpty
        && _controllerDepart.text.isNotEmpty && _controllerDest.text.isNotEmpty && _controllerTakeOff.text.isNotEmpty
        && _controllerArrival.text.isNotEmpty && _controllerDate.text.isNotEmpty) {
      var newItem = ReservationList(
        ReservationList.ID++,
        _controllerFlight.text,
        _controllerFname.text,
        _controllerLname.text,
        _controllerDepart.text,
        _controllerDest.text,
        _controllerTakeOff.text,
        _controllerArrival.text,
        _controllerDate.text,
      );
      setState(() {
        reserved.add(newItem);
      });
      myDao.insertItem(newItem);
      _controllerFlight.clear();
      _controllerFname.clear();
      _controllerLname.clear();
      _controllerDepart.clear();
      _controllerDest.clear();
      _controllerTakeOff.clear();
      _controllerArrival.clear();
      _controllerDate.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added: ${newItem.toString()}')),
      );
    } else if (_controllerFlight.text.isEmpty || _controllerFname.text.isEmpty || _controllerLname.text.isEmpty
        || _controllerDepart.text.isEmpty || _controllerDest.text.isEmpty || _controllerTakeOff.text.isEmpty
        || _controllerArrival.text.isEmpty || _controllerDate.text.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)?.translate('invalid_inputs') ?? 'Invalid Data'),
            content: Text(AppLocalizations.of(context)?.translate('fill_all') ?? "Fill all fields"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.translate('bookings') ?? "Bookings"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)?.translate('instructions') ?? "Instructions"),
                    content: Text(AppLocalizations.of(context)?.translate('instruction_text') ?? "Use the text"
                        " fields below to create a reservation and click the + button to add it. All fields must"
                        " be filled out for the reservation to be made."),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)?.translate('fill_all') ?? "Fill all fields"),
            TextField(
              controller: _controllerFlight,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.translate('flight_name') ?? "Flight Name:",
              ),
            ),
            TextField(
              controller: _controllerFname,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.translate('first_name') ?? 'First Name',
              ),
            ),
            TextField(
              controller: _controllerLname,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.translate('last_name') ?? 'Last Name',
              ),
            ),
            TextField(
              controller: _controllerDepart,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.translate('departure') ?? 'Departure City',
              ),
            ),
            TextField(
              controller: _controllerDest,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.translate('destination') ?? 'Destination City:',
              ),
            ),
            TextField(
              controller: _controllerTakeOff,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.translate('start_time') ?? 'Departure Time',
              ),
            ),
            TextField(
              controller: _controllerArrival,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.translate('end_time') ?? 'Arrival Time',
              ),
            ),
            TextField(
              controller: _controllerDate,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.translate('date') ?? "Date:",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addItem,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
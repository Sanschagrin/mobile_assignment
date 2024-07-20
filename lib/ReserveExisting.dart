import 'package:flutter/material.dart';
import 'AppLocalizations.dart';
import 'ReservationList.dart';
import 'ReservationsDAO.dart';
import 'ReservationDatabase.dart';
/*
 *Gregory Mah 041114855
 *This class is the reserve existing class, it will be responsible for using existing flights and customers
 * to make database insertions. In it, there are several predefined variables to flights, customers and days.
 * The user will be able to select which of these values match the desired reservation and add them together
 * and the class will distinguish the database values and inserts them in.
 */
class ReserveExisting extends StatefulWidget {
  const ReserveExisting({super.key});

  @override
  _ReserveExistingState createState() => _ReserveExistingState();
}

class _ReserveExistingState extends State<ReserveExisting> {
  var reserved = <ReservationList>[]; /// List to hold reservations added in this session.
  String? selectedFlight;/// Selected flight for the reservation.
  String? selectedCustomer; /// Selected customer for the reservation.
  String? selectedDate; /// Selected date for the reservation.
  late ReservationsDAO myDao;/// Data Access Object for interacting with the reservations database.

  /// Predefined list of flights available for selection.
  List<String> predefinedFlights = [
    'AC 456 - Ottawa - Montreal - 11:00 - 14:00',
    'AC 457 - Toronto - Vancouver - 15:00 - 18:00',
    'AC 345 - Montreal - Calgary - 09:00 - 12:00',
    'AC 727 - Toronto - Hong Kong - 07:00 - 16:00',
    'AC 788 - Montreal - London - 23:00 - 08:00',
    'AC 777 - Calgary - Las Vegas - 00:00 - 06:00',
    'AC 322 - Ottawa - Los Angelos - 13:00 - 10:00'
  ];
  /// Predefined list of customers available for selection.
  List<String> predefinedCustomers = ['Gregory Mah', 'Sammy Prasad', 'Mylene Storm',
                                      'Tanek Stuttgraham', 'Quelly Laroa', 'Peter Stainforth', 'Jacob Spears'];
  /// Predefined list of days available for selection.
  List<String> predefinedDates = ['2024-07-20', '2024-07-21',
                                  '2024-07-22', '2024-07-23',
                                  '2024-07-24', '2024-07-25', '2024-07-26'];

  @override
  void initState() {
    super.initState();

    /// Initialize the DAO
    $FloorReservationDatabase.databaseBuilder('app_database.db').build().then((database) {
      myDao = database.getDao;
    });
  }
/*
 * Adds the reservation to the database by distinguishing the values in the flights drop down button form
 * field to their corresponding database columns. It splits the customer value in to two seperate values and
 * inserts them into first and last name. It displays a snack bar on success and an alert dialog on invalid data
 * entry.
 */
  void addReservation() {
    if (selectedFlight != null && selectedCustomer != null && selectedDate != null) {
      var flightParts = selectedFlight!.split(' - ');
      if (flightParts.length == 5) {
        var newItem = ReservationList(
            ReservationList.ID++,
            flightParts[0],
            selectedCustomer!.split(' ')[0],
            selectedCustomer!.split(' ')[1],
            flightParts[1],
            flightParts[2],
            flightParts[3],
            flightParts[4],
            selectedDate!
        );
        setState(() {
          reserved.add(newItem);
        });

        myDao.insertItem(newItem).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Reservation added: ${newItem.toString()}')));
          setState(() {
            selectedFlight = null;
            selectedCustomer = null;
            selectedDate = null;
          });
        }).catchError((error) {
          AlertDialog(
              title: Text(AppLocalizations.of(context)?.translate('unable_to_add') ?? "Unable to add to database"),
              content: Text('$error'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK')
                )
              ]);
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(AppLocalizations.of(context)?.translate('invalid_inputs') ?? "Invalid Inputs"),
                content: Text(AppLocalizations.of(context)?.translate('fill_all') ?? "Please make sure to fill in all the fields"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  )
                ]
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.translate('add_reservation') ?? "Add Reservation"),
        leading: Container( child:
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/pageTwo');
            },
          ),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedFlight,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)?.translate('sel_flight') ?? "Select Flight"),
              items: predefinedFlights.map((flight) {
                return DropdownMenuItem(
                  value: flight,
                  child: Text(flight),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFlight = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: selectedCustomer,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)?.translate('sel_customer') ?? "Select Customer"),
              items: predefinedCustomers.map((customer) {
                return DropdownMenuItem(
                  value: customer,
                  child: Text(customer),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCustomer = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: selectedDate,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)?.translate('sel_date') ?? "Select Date"),
              items: predefinedDates.map((date) {
                return DropdownMenuItem(
                  value: date,
                  child: Text(date),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDate = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addReservation,
              child: Text(AppLocalizations.of(context)?.translate('add_reservation') ?? "Add Reservation"),
            ),
          ],
        ),
      ),
    );
  }
}
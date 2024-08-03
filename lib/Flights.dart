import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class FlightsPage extends StatefulWidget {
  @override
  _FlightsPageState createState() => _FlightsPageState();
}

class _FlightsPageState extends State<FlightsPage> {
  final EncryptedSharedPreferences _encryptedPrefs = EncryptedSharedPreferences();
  List<Map<String, dynamic>> _flights = [];

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    try {
      String flightsJson = await _encryptedPrefs.getString('flights');
      if (flightsJson != null && flightsJson.isNotEmpty) {
        List<dynamic> flightsList = jsonDecode(flightsJson);
        _flights = flightsList.map((flight) => Map<String, dynamic>.from(flight)).toList();
      }
    } catch (e) {
      print("Error loading flights: $e");
    }
    setState(() {});
  }

  Future<void> _saveFlights() async {
    try {
      String flightsJson = jsonEncode(_flights);
      await _encryptedPrefs.setString('flights', flightsJson);
    } catch (e) {
      print("Error saving flights: $e");
    }
  }

  void _addFlight(Map<String, dynamic> flight) {
    setState(() {
      _flights.add(flight);
      _saveFlights();
    });
  }

  void _removeFlight(int index) {
    setState(() {
      _flights.removeAt(index);
      _saveFlights();
    });
  }

  void _updateFlight(int index, Map<String, dynamic> updatedFlight) {
    setState(() {
      _flights[index] = updatedFlight;
      _saveFlights();
    });
  }

  void _showEditDialog(int index) {
    final _departureCityController = TextEditingController(text: _flights[index]['departureCity']);
    final _destinationCityController = TextEditingController(text: _flights[index]['destinationCity']);
    final _departureTimeController = TextEditingController(text: _flights[index]['departureTime']);
    final _arrivalTimeController = TextEditingController(text: _flights[index]['arrivalTime']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Flight"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _departureCityController,
                decoration: InputDecoration(labelText: 'Departure City'),
              ),
              TextField(
                controller: _destinationCityController,
                decoration: InputDecoration(labelText: 'Destination City'),
              ),
              TextField(
                controller: _departureTimeController,
                decoration: InputDecoration(labelText: 'Departure Time'),
              ),
              TextField(
                controller: _arrivalTimeController,
                decoration: InputDecoration(labelText: 'Arrival Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateFlight(index, {
                  'departureCity': _departureCityController.text,
                  'destinationCity': _destinationCityController.text,
                  'departureTime': _departureTimeController.text,
                  'arrivalTime': _arrivalTimeController.text,
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog() {
    final _departureCityController = TextEditingController();
    final _destinationCityController = TextEditingController();
    final _departureTimeController = TextEditingController();
    final _arrivalTimeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Flight"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _departureCityController,
                decoration: InputDecoration(labelText: 'Departure City'),
              ),
              TextField(
                controller: _destinationCityController,
                decoration: InputDecoration(labelText: 'Destination City'),
              ),
              TextField(
                controller: _departureTimeController,
                decoration: InputDecoration(labelText: 'Departure Time'),
              ),
              TextField(
                controller: _arrivalTimeController,
                decoration: InputDecoration(labelText: 'Arrival Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_departureCityController.text.isEmpty ||
                    _destinationCityController.text.isEmpty ||
                    _departureTimeController.text.isEmpty ||
                    _arrivalTimeController.text.isEmpty) {
                  _showValidationErrorDialog();
                } else {
                  _addFlight({
                    'departureCity': _departureCityController.text,
                    'destinationCity': _destinationCityController.text,
                    'departureTime': _departureTimeController.text,
                    'arrivalTime': _arrivalTimeController.text,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showValidationErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Validation Error"),
          content: Text("All fields are required."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flights"),
      ),
      body: ListView.builder(
        itemCount: _flights.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("${_flights[index]['departureCity']} to ${_flights[index]['destinationCity']}"),
            subtitle: Text("Departure: ${_flights[index]['departureTime']} Arrival: ${_flights[index]['arrivalTime']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditDialog(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeFlight(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

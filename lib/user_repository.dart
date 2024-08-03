import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class UserRepository {
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  Future<void> saveFlight(Map<String, String> flight) async {
    List<Map<String, String>> flights = await loadFlights();
    flights.add(flight);
    await _prefs.setString('flights', flights.toString());
  }

  Future<void> updateFlight(int index, Map<String, String> flight) async {
    List<Map<String, String>> flights = await loadFlights();
    flights[index] = flight;
    await _prefs.setString('flights', flights.toString());
  }

  Future<void> deleteFlight(int index) async {
    List<Map<String, String>> flights = await loadFlights();
    flights.removeAt(index);
    await _prefs.setString('flights', flights.toString());
  }

  Future<List<Map<String, String>>> loadFlights() async {
    String flightsString = await _prefs.getString('flights') ?? '[]';
    List<Map<String, String>> flights = (flightsString.isEmpty)
        ? []
        : List<Map<String, String>>.from(
      (flightsString as List).map((item) => Map<String, String>.from(item)),
    );
    return flights;
  }
}

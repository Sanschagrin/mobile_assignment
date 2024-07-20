import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'AppLocalizations.dart';
import 'ReservationList.dart';
import 'ReservationsDAO.dart';
import 'ReservationDatabase.dart';

/*
 *Gregory Mah 041114855
 *This class is the reservations class, it will be responsible for holding the listview with all the reservations
 *in the database. In it there is a search function that will allow you to find a specific reservation if any
 *names/flights match your search. It also features two buttons linking to pages to create new bookings and to make
 *bookings using existing flights and customers.
 */
class Reservations extends StatefulWidget {
  final Function(Locale) onLanguageChange; /// Callback to change language

  const Reservations({super.key, required this.onLanguageChange});

  @override
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  var reserved = <ReservationList>[]; ///Array to hold database instances
  late TextEditingController _controllerSearch; ///Text controller for search user inputs
  late ReservationsDAO myDao; ///ReservationsDAO object to allow for database operations in this class
  late EncryptedSharedPreferences _encryptedPrefs;///encrypted share preferences object to allow for search text to be saved
  String? selectedItem;///nullable string value to hold the display of database objects to be clicked on for further details
  Locale locale = Locale('en'); ///set a default language

  @override
  void initState() {
    super.initState();

    _controllerSearch = TextEditingController();
    _encryptedPrefs = EncryptedSharedPreferences();

    $FloorReservationDatabase.databaseBuilder('app_database.db').build().then((database) {
      myDao = database.getDao;
      loadReservations();
    });

    loadSharedPrefs();
  }
  void changeLanguage(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }
  @override
  void dispose() {
    _controllerSearch.dispose();
    super.dispose();
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
   *Save the text value of the search controller into encrypted preferences to be used on next page load
   */
  void saveSharedPrefs() async {
    await _encryptedPrefs.setString('last_search', _controllerSearch.text);
  }
  /*
   *Load the text value of the search controller from encrypted preferences so the same search can be made again
   */
  void loadSharedPrefs() async {
    String? lastSearch = await _encryptedPrefs.getString('last_search') ?? '';
    setState(() {
      _controllerSearch.text = lastSearch;
    });
  }
  /*
   *Method to be used to load listview with database objects that match a search query defined in the
   * ReservationsDao class. % symbols are added to make searchs with approximate similarities appear.
   */
  void searchItems(String query) async {
    saveSharedPrefs();
    final results = await myDao.searchSql('%$query%');
    setState(() {
      reserved = results;
    });
  }
  /*
   *Link to the new bookings page to be used by the bookings button and loads new reservations
   */
  void bookings() async {
    await Navigator.pushNamed(context, '/bookings');
    loadReservations();
  }
  /*
   *Link to the reserve existing page to be used by the make a reservation with existing details button and loads new reservations
   */
  void reserveExisting() {
    Navigator.pushNamed(context, '/ReserveExisting');
    loadReservations();
  }
  /*
   *Widget builder for the reservations page defined here so that the page can be reactive to screen size.
   * It includes utilizations for all methods defined above.
   */
  Widget ReservationsWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controllerSearch,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.translate('search'),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      searchItems(_controllerSearch.text);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child:
            ElevatedButton(
              onPressed: bookings,
              child: Text(AppLocalizations.of(context)?.translate('creating_new_booking') ?? "Create New Booking"),
            ),
            ),
            Expanded(child:
            ElevatedButton(
              onPressed: reserveExisting,
              child: Text(AppLocalizations.of(context)?.translate('reserve_existing') ?? "Reserve Existing"),
            ),
            )
          ],
        ),
        Expanded(
          child: (reserved.isNotEmpty)
              ? ListView.builder(
            itemCount: reserved.length,
            itemBuilder: (context, rowNum) {
              return ListTile(
                title: Text(
                    '${reserved[rowNum].firstName} ${reserved[rowNum].lastName} - ${reserved[rowNum].flight}'),
                onTap: () {
                  setState(() {
                    selectedItem =
                    '${reserved[rowNum].firstName} ${reserved[rowNum].lastName}';
                  });
                },
              );
            },
          )
              : Center(
            child: Text(AppLocalizations.of(context)?.translate('no_reservations_yet') ?? "No reservations yet"),
          ),
        ),
      ],
    );
  }

  /*
   *Widget builder for the details page defined here so that the page can be reactive to screen size.
   * Allows users to display reservation details, delete reservations and return back to the reservations
   * page.
   */
  Widget DetailsPage() {
    if (selectedItem == null) {
      return Text(AppLocalizations.of(context)?.translate('nothing_selected') ?? "Nothing is selected");
    } else {
      int rowNum = reserved.indexWhere(
              (item) => '${item.firstName} ${item.lastName}' == selectedItem);
      return Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Column for headers
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)?.translate('name') ?? 'Name:'),
                Text(AppLocalizations.of(context)?.translate('flight') ?? 'Flight:'),
                Text(AppLocalizations.of(context)?.translate('destination') ?? 'Departure City:'),
                Text(AppLocalizations.of(context)?.translate('departure') ?? 'Destination City:'),
                Text(AppLocalizations.of(context)?.translate('start_time') ?? 'Takeoff Time:'),
                Text(AppLocalizations.of(context)?.translate('end_time') ?? 'Arrival Time:'),
                Text(AppLocalizations.of(context)?.translate('date') ?? 'Day:'),
              ],
            ),
            SizedBox(width: 16.0), // Space between columns
            // Column for values
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${reserved[rowNum].firstName} ${reserved[rowNum].lastName}'),
                Text(reserved[rowNum].flight),
                Text(reserved[rowNum].departure),
                Text(reserved[rowNum].destination),
                Text(reserved[rowNum].takeOff),
                Text(reserved[rowNum].arrival),
                Text(reserved[rowNum].date),
              ],
            ),
          ],
        ),
          Padding(padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedItem = null;
                  });
                },
                child: Text(AppLocalizations.of(context)?.translate('go_back') ?? "Go back")),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)?.translate('delete') ?? 'Delete'),
            onPressed: () {
              setState(() {
                var itm = reserved[rowNum];
                myDao.deleteItem(itm);
                reserved.removeAt(rowNum);
                selectedItem = null;
              });
            },
          )
        ],
      ));
    }
  }

  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) {
      return Row(
        children: [
          Expanded(flex: 2, child: ReservationsWidget()),
          Expanded(flex: 2, child: DetailsPage())
        ],
      );
    } else {
      if (selectedItem == null) {
        return ReservationsWidget();
      } else {
        return DetailsPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      locale: locale,
      home: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.translate('title') ?? "Reservations"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/pageOne');
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            DropdownButton<Locale>(
              value: Localizations.localeOf(context),
              icon: const Icon(Icons.language),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  widget.onLanguageChange(newLocale);
                  setState(() {});
                }
              },
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('fr'),
                  child: Text('French'),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.help),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)?.translate('instructions') ?? 'Instructions'),
                      content: Text(AppLocalizations.of(context)?.translate('search_instruct') ?? "Cannot load"),
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
        body: responsiveLayout(),
      ),
    );
  }
}
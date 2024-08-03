import 'package:flutter/material.dart';
import 'package:mobile_assignment/AppLocalizations.dart';
import 'Reservations.dart';
import 'Airplanes.dart';
import 'Customers.dart';
import 'Flights.dart';
import 'Bookings.dart';
import 'ReserveExisting.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

  class _MyAppState extends State<MyApp>{
    var locale = Locale("en");

    void _changeLanguage(Locale newLocale){
      setState(() {
        locale = newLocale;
      });
    }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/pageOne'   :   (context) => const LandingPage(title: 'Welcome to BOEING'),
        '/pageTwo'  :    (context) => Reservations(onLanguageChange: _changeLanguage),
        '/pageThree' : (context) => const Customers(),
        '/pageFour' : (context) => const Airplanes(),
        '/pageFive' : (context) => FlightsPage(),
        '/bookings' : (context) => const Bookings(),
        '/ReserveExisting' : (context) => const ReserveExisting(),


      },
      title: 'BOEING',
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute : '/pageOne'  ,
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          automaticallyImplyLeading:false
        ),
        body: Container(
          color: Colors.blueGrey,

          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: reservations,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            elevation: 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Reservations", style: TextStyle(color: Colors.black, fontSize: 25)),
                              Image.asset("images/Reservations.jpg", height: 150, width: 300,)
                            ],
                          )),
                      ElevatedButton(onPressed: customers,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            elevation: 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Customers", style: TextStyle(color: Colors.black, fontSize: 25)),
                              Image.asset("images/customers.png", height: 150, width: 300,)
                            ],
                          )),
                    ]),
                Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: flights,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            elevation: 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Flights", style: TextStyle(color: Colors.black, fontSize: 25)),
                              Image.asset("images/Flight.jpg", height: 150, width: 300,)
                            ],
                          )),
                      ElevatedButton(onPressed: airplanes,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            elevation: 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Airplanes", style: TextStyle(color: Colors.black, fontSize: 25)),
                              Image.asset("images/airplanes.jpg", height: 150, width: 300,)
                            ],
                          ))
                    ])
              ],
            ),
          ),
        )
    );
  }


  void reservations() {
    Navigator.pushNamed(context, '/pageTwo');
  }

  void airplanes() {
    Navigator.pushNamed(context, '/pageFour');
  }

  void flights() {
    Navigator.pushNamed(context, '/pageFive');
  }

  void customers() {
    Navigator.pushNamed(context, '/pageThree');
  }
}
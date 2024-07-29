import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
//class imports
import 'NewCustomer.dart';

class Customers extends StatelessWidget {
  const Customers({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customers',
      routes: {
        '/newCust': (context) => NewCustomer()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Customer page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void buttonClicked() {
    Navigator.pushNamed( context, '/newCust' );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed:buttonClicked,
                        child: Text ("Add new customer")
                    ),

                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }
}

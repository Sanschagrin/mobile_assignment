import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewCustomer extends StatefulWidget {
@override
  State<NewCustomer> createState() => NewCustomerState();
}

class NewCustomerState extends State<NewCustomer> {
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
              child: Row(
                children: [
                  Text ("here I'll put the customer fields")
                ],
              ),
            ),
          ]
        )
      )
    );
  }
}
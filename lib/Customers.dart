import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
//class imports
import 'CustomerRecord.dart';
import 'CustomersDAO.dart';
import 'CustomersDatabase.dart';
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
  late CustomersDAO myDAO;
  List<CustomerRecord> customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() async {
    final database = await $FloorCustomersDatabase.databaseBuilder('app_database.db').build();
    myDAO = database.getDao;
    final customerList = await myDAO.getAllRecords();
    setState(() {
      customers = customerList;
    });
  }
  void buttonClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewCustomer()),
    ).then((_) {
      _loadCustomers(); // Reload the customers after coming back from creating new ones
    });
  }

  void editCustomer(CustomerRecord customer) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewCustomer(customer: customer)),
    ).then((_) {
      _loadCustomers(); // Reload the customers after coming back from editing
    });
  }

  void deleteCustomer(CustomerRecord customer) async {
    await myDAO.deleteItem(customer);
    setState(() {
      customers.remove(customer);
    });
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
              Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: customers.length,
                itemBuilder: (BuildContext context, int index) {
                  final customer = customers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10.0),
                      title: Text("${customer.firstName} ${customer.lastName}", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Address: ${customer.address}"),
                          Text("Postal Code: ${customer.postalCode}"),
                          Text("City: ${customer.city}"),
                          Text("Country: ${customer.country}"),
                          Text("Birthday: ${customer.birthday}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => editCustomer(customer),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteCustomer(customer),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              )
              )
            ]
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//class imports
import 'CustomerRecord.dart';
import 'CustomersDAO.dart';
import 'CustomersDatabase.dart';
import 'NewCustomer.dart';
import 'EditCustomer.dart';
import 'AppLocalizations.dart';


class Customers extends StatefulWidget {
  final Function(Locale) onLanguageChange; /// Callback to change language

  const Customers({super.key, required this.onLanguageChange});

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  late CustomersDAO myDAO;
  List<CustomerRecord> customers = [];
  Locale locale = Locale('en'); ///set english to default language

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    print('onLanguageChange: ${widget.onLanguageChange}'); // Debug print
  }
  void changeLanguage(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
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
      MaterialPageRoute(builder: (context) => EditCustomer(customer: customer)),
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          DropdownButton<Locale>(
            value: Localizations.localeOf(context),
            icon: const Icon(Icons.language),
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                widget.onLanguageChange(newLocale);
                setState(() {
                  locale = newLocale; // Update the local variables
                });
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
                    content: Text(AppLocalizations.of(context)?.translate('cust_instruct') ?? "browse cust"),
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
        title: Text(AppLocalizations.of(context)?.translate('customers') ?? 'Customers'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/pageOne');
          },
        ),
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
                        child: Text (AppLocalizations.of(context)?.translate('add_new_customer') ?? "Add new customer")
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
                          Text("${customer.address}" " " "${customer.postalCode}" " " "${customer.city}" " " "${customer.country}"),
                          Text("${customer.birthday}"),
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
    ));
  }
}

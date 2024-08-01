import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//class imports
import 'CustomerRecord.dart';
import 'CustomersDAO.dart';
import 'CustomersDatabase.dart';
import 'NewCustomer.dart';
import 'EditCustomer.dart';
import 'AppLocalizations.dart';

/// A stateful widget that displays a list of customers and supports multiple languages.

class Customers extends StatefulWidget {
  /// Callback to change the language of the app.
  final Function(Locale) onLanguageChange;

  /// Creates a [Customers] widget.
  const Customers({super.key, required this.onLanguageChange});

  @override
  _CustomersState createState() => _CustomersState();
}

/// The state class for the [Customers] widget.
class _CustomersState extends State<Customers> {
  late CustomersDAO myDAO;
  List<CustomerRecord> customers = [];
  Locale locale = Locale('en'); ///set english to default language
  CustomerRecord? selectedCustomer;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  /// Changes the language of the app.
  ///
  /// This method is called when the user selects a different language
  /// from the dropdown menu in the app bar.
  ///
  /// [newLocale] is the new locale to set for the app.
  void changeLanguage(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }

  /// Loads the list of customers from the database.
  ///
  /// This method is called during initialization and after adding or editing a customer.
  void _loadCustomers() async {
    final database = await $FloorCustomersDatabase.databaseBuilder('app_database.db').build();
    myDAO = database.getDao;
    final customerList = await myDAO.getAllRecords();
    setState(() {
      customers = customerList;
    });
  }

  /// Navigates to the [NewCustomer] screen.
  ///
  /// This method is called when the "Add new customer" button is clicked.
  /// After returning from the [NewCustomer] screen, the list of customers is reloaded.
  void buttonClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewCustomer()),
    ).then((_) {
      _loadCustomers(); // Reload the customers after coming back from creating new ones
    });
  }

  /// Navigates to the [EditCustomer] screen.
  ///
  /// This method is called when the edit button is clicked for a specific customer.
  /// After returning from the [EditCustomer] screen, the list of customers is reloaded.
  ///
  /// [customer] is the customer record to edit.
  void editCustomer(CustomerRecord customer) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditCustomer(customer: customer)),
    ).then((_) {
      _loadCustomers(); // Reload the customers after coming back from editing
    });
  }

  /// Deletes a customer from the database.
  ///
  /// This method is called when the delete button is clicked for a specific customer.
  /// The customer is removed from the list of customers after deletion.
  ///
  /// [customer] is the customer record to delete.
  void deleteCustomer(CustomerRecord customer) async {
    await myDAO.deleteItem(customer);
    setState(() {
      customers.remove(customer);
    });
  }

  /// Selects a customer to display their details.
  ///
  /// This method is called when a customer is tapped in the list.
  ///
  /// [customer] is the customer record to select.
  void selectCustomer(CustomerRecord customer) {
    setState(() {
      selectedCustomer = customer;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isTabletOrDesktop = MediaQuery.of(context).size.width > 600;

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
      child: Row(
        children: [
          Expanded(
            flex: 2,
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
                          onTap: () => selectCustomer(customer),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
          if (isTabletOrDesktop && selectedCustomer != null) Expanded(
          flex: 3,
          child: CustomerDetails(customer: selectedCustomer!),
          ),
        ],
        ),
      ),
    ),
  );
}
}

/// A stateless widget that displays the details of a selected customer.
class CustomerDetails extends StatelessWidget {
  /// The customer record to display.
  final CustomerRecord customer;

  /// Creates a [CustomerDetails] widget.
  CustomerDetails({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${AppLocalizations.of(context)?.translate('first_name') ?? 'First Name'}: ${customer.firstName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("${AppLocalizations.of(context)?.translate('last_name') ?? 'First Name'}: ${customer.lastName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("${AppLocalizations.of(context)?.translate('address') ?? 'First Name'}: ${customer.address}"),
          Text("${AppLocalizations.of(context)?.translate('postal') ?? 'First Name'}: ${customer.postalCode}"),
          Text("${AppLocalizations.of(context)?.translate('city') ?? 'First Name'}: ${customer.city}"),
          Text("${AppLocalizations.of(context)?.translate('country') ?? 'First Name'}: ${customer.country}"),
          Text("${AppLocalizations.of(context)?.translate('birthdate') ?? 'First Name'}: ${customer.birthday}"),
        ],
      ),
    );
  }
}

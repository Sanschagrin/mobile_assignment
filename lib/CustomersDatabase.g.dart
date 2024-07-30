// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomersDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $CustomersDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $CustomersDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $CustomersDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<CustomersDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorCustomersDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $CustomersDatabaseBuilderContract databaseBuilder(String name) =>
      _$CustomersDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $CustomersDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$CustomersDatabaseBuilder(null);
}

class _$CustomersDatabaseBuilder implements $CustomersDatabaseBuilderContract {
  _$CustomersDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $CustomersDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $CustomersDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<CustomersDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$CustomersDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$CustomersDatabase extends CustomersDatabase {
  _$CustomersDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CustomersDAO? _getDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CustomerRecord` (`id` INTEGER NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `address` TEXT NOT NULL, `postalCode` TEXT NOT NULL, `city` TEXT NOT NULL, `country` TEXT NOT NULL, `birthday` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CustomersDAO get getDao {
    return _getDaoInstance ??= _$CustomersDAO(database, changeListener);
  }
}

class _$CustomersDAO extends CustomersDAO {
  _$CustomersDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _customerRecordInsertionAdapter = InsertionAdapter(
            database,
            'CustomerRecord',
            (CustomerRecord item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'postalCode': item.postalCode,
                  'city': item.city,
                  'country': item.country,
                  'birthday': item.birthday
                }),
        _customerRecordUpdateAdapter = UpdateAdapter(
            database,
            'CustomerRecord',
            ['id'],
            (CustomerRecord item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'postalCode': item.postalCode,
                  'city': item.city,
                  'country': item.country,
                  'birthday': item.birthday
                }),
        _customerRecordDeletionAdapter = DeletionAdapter(
            database,
            'CustomerRecord',
            ['id'],
            (CustomerRecord item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'postalCode': item.postalCode,
                  'city': item.city,
                  'country': item.country,
                  'birthday': item.birthday
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CustomerRecord> _customerRecordInsertionAdapter;

  final UpdateAdapter<CustomerRecord> _customerRecordUpdateAdapter;

  final DeletionAdapter<CustomerRecord> _customerRecordDeletionAdapter;

  @override
  Future<List<CustomerRecord>> getAllRecords() async {
    return _queryAdapter.queryList('Select * from CustomerRecord',
        mapper: (Map<String, Object?> row) => CustomerRecord(
            row['id'] as int,
            row['firstName'] as String,
            row['lastName'] as String,
            row['address'] as String,
            row['postalCode'] as String,
            row['city'] as String,
            row['country'] as String,
            row['birthday'] as String));
  }

  @override
  Future<void> insertItem(CustomerRecord itm) async {
    await _customerRecordInsertionAdapter.insert(itm, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItem(CustomerRecord itm) {
    return _customerRecordUpdateAdapter.updateAndReturnChangedRows(
        itm, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteItem(CustomerRecord itm) {
    return _customerRecordDeletionAdapter.deleteAndReturnChangedRows(itm);
  }
}

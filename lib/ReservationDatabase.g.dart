// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReservationDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $ReservationDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $ReservationDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $ReservationDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<ReservationDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorReservationDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ReservationDatabaseBuilderContract databaseBuilder(String name) =>
      _$ReservationDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ReservationDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$ReservationDatabaseBuilder(null);
}

class _$ReservationDatabaseBuilder
    implements $ReservationDatabaseBuilderContract {
  _$ReservationDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $ReservationDatabaseBuilderContract addMigrations(
      List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $ReservationDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<ReservationDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ReservationDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ReservationDatabase extends ReservationDatabase {
  _$ReservationDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ReservationsDAO? _getDaoInstance;

  Future<sqflite.Database> open(
      String path,
      List<Migration> migrations, [
        Callback? callback,
      ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
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
            'CREATE TABLE IF NOT EXISTS `ReservationList` (`id` INTEGER NOT NULL, `flight` TEXT NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `destination` TEXT NOT NULL, `departure` TEXT NOT NULL, `takeOff` TEXT NOT NULL, `arrival` TEXT NOT NULL, `date` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ReservationsDAO get getDao {
    return _getDaoInstance ??= _$ReservationsDAO(database, changeListener);
  }
}

class _$ReservationsDAO extends ReservationsDAO {
  _$ReservationsDAO(
      this.database,
      this.changeListener,
      )   : _queryAdapter = QueryAdapter(database),
        _reservationListInsertionAdapter = InsertionAdapter(
            database,
            'ReservationList',
                (ReservationList item) => <String, Object?>{
              'id': item.id,
              'flight': item.flight,
              'firstName': item.firstName,
              'lastName': item.lastName,
              'destination': item.destination,
              'departure': item.departure,
              'takeOff': item.takeOff,
              'arrival': item.arrival,
              'date': item.date
            }),
        _reservationListUpdateAdapter = UpdateAdapter(
            database,
            'ReservationList',
            ['id'],
                (ReservationList item) => <String, Object?>{
              'id': item.id,
              'flight': item.flight,
              'firstName': item.firstName,
              'lastName': item.lastName,
              'destination': item.destination,
              'departure': item.departure,
              'takeOff': item.takeOff,
              'arrival': item.arrival,
              'date': item.date
            }),
        _reservationListDeletionAdapter = DeletionAdapter(
            database,
            'ReservationList',
            ['id'],
                (ReservationList item) => <String, Object?>{
              'id': item.id,
              'flight': item.flight,
              'firstName': item.firstName,
              'lastName': item.lastName,
              'destination': item.destination,
              'departure': item.departure,
              'takeOff': item.takeOff,
              'arrival': item.arrival,
              'date': item.date
            });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ReservationList> _reservationListInsertionAdapter;

  final UpdateAdapter<ReservationList> _reservationListUpdateAdapter;

  final DeletionAdapter<ReservationList> _reservationListDeletionAdapter;

  @override
  Future<List<ReservationList>> getAll() async {
    return _queryAdapter.queryList('Select * FROM ReservationList',
        mapper: (Map<String, Object?> row) => ReservationList(
            row['id'] as int,
            row['flight'] as String,
            row['firstName'] as String,
            row['lastName'] as String,
            row['destination'] as String,
            row['departure'] as String,
            row['takeOff'] as String,
            row['arrival'] as String,
            row['date'] as String));
  }

  @override
  Future<List<ReservationList>> searchSql(String search) async {
    return _queryAdapter.queryList(
        'Select * FROM ReservationList WHERE firstName LIKE ?1 OR lastName LIKE ?1 OR flight LIKE ?1',
        mapper: (Map<String, Object?> row) => ReservationList(row['id'] as int, row['flight'] as String, row['firstName'] as String, row['lastName'] as String, row['destination'] as String, row['departure'] as String, row['takeOff'] as String, row['arrival'] as String, row['date'] as String),
        arguments: [search]);
  }

  @override
  Future<void> insertItem(ReservationList item) async {
    await _reservationListInsertionAdapter.insert(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateList(ReservationList item) {
    return _reservationListUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteItem(ReservationList item) {
    return _reservationListDeletionAdapter.deleteAndReturnChangedRows(item);
  }
}

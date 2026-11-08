import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'models/transfer_type.dart';
import 'daos/accounts_dao.dart';
import 'daos/transfers_dao.dart';

part 'database.g.dart';

@DataClassName('Account')
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('Transfer')
class Transfers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => textEnum<TransferType>()();
  RealColumn get amount => real()();
  IntColumn get commission => integer().withDefault(const Constant(0))();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
}

@DriftDatabase(
  tables: [Accounts, Transfers],
  daos: [AccountsDao, TransfersDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'hawalati_db');
  }
}

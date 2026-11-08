import 'package:drift/drift.dart';
import '../database.dart';

part 'accounts_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountsDao extends DatabaseAccessor<AppDatabase> with _$AccountsDaoMixin {
  AccountsDao(super.db);

  Stream<List<Account>> watchAllAccounts() {
    return (select(accounts)..orderBy([(a) => OrderingTerm.asc(a.createdAt)]))
        .watch();
  }

  Future<int> insertAccount(String name) {
    return into(accounts).insert(AccountsCompanion.insert(name: name));
  }

  Future<Account?> getFirstAccount() {
    return (select(accounts)..limit(1)).getSingleOrNull();
  }

  Future<void> ensureDefaultAccount() async {
    final first = await getFirstAccount();
    if (first == null) {
      await insertAccount('شخصي');
    }
  }
}

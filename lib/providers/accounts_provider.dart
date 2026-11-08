import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import 'database_provider.dart';

final accountsStreamProvider = StreamProvider<List<Account>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.accountsDao.watchAllAccounts();
});

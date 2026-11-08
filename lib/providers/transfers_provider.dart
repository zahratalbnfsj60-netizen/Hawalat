import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../data/models/transfer_type.dart';
import '../data/models/transfer_summary.dart';
import 'active_account_provider.dart';
import 'database_provider.dart';

final receivedTransfersProvider =
    StreamProvider.family<List<Transfer>, int>((ref, accountId) {
  final db = ref.watch(databaseProvider);
  return db.transfersDao.watchTransfersByType(accountId, TransferType.received);
});

final paidTransfersProvider =
    StreamProvider.family<List<Transfer>, int>((ref, accountId) {
  final db = ref.watch(databaseProvider);
  return db.transfersDao.watchTransfersByType(accountId, TransferType.paid);
});

final summaryProvider =
    StreamProvider.family<TransferSummary, int>((ref, accountId) {
  final db = ref.watch(databaseProvider);
  return db.transfersDao.watchSummary(accountId);
});

// فلترة البحث والتاريخ
final receivedSearchQueryProvider = StateProvider<String>((ref) => '');
final paidSearchQueryProvider = StateProvider<String>((ref) => '');
final receivedDateFilterProvider = StateProvider<DateFilter>((ref) => DateFilter.all);
final paidDateFilterProvider = StateProvider<DateFilter>((ref) => DateFilter.all);

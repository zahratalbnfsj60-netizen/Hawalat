import 'package:drift/drift.dart';
import '../database.dart';
import '../models/transfer_summary.dart';
import '../models/transfer_type.dart';

part 'transfers_dao.g.dart';

@DriftAccessor(tables: [Transfers])
class TransfersDao extends DatabaseAccessor<AppDatabase> with _$TransfersDaoMixin {
  TransfersDao(super.db);

  Stream<List<Transfer>> watchTransfersByType(int accountId, TransferType type) {
    return (select(transfers)
          ..where((t) => t.accountId.equals(accountId) & t.type.equalsValue(type))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Stream<TransferSummary> watchSummary(int accountId) {
    final query = customSelect(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN type = 'received' THEN amount ELSE 0 END), 0) AS total_received,
        COALESCE(SUM(CASE WHEN type = 'paid' THEN amount ELSE 0 END), 0) AS total_paid,
        COALESCE(SUM(CASE WHEN type = 'paid' THEN commission ELSE 0 END), 0) AS total_commission,
        COUNT(*) AS total_count,
        COALESCE(SUM(CASE WHEN type = 'paid' THEN 1 ELSE 0 END), 0) AS paid_count
      FROM transfers WHERE account_id = ?
      ''',
      variables: [Variable.withInt(accountId)],
      readsFrom: {transfers},
    );

    return query.watchSingle().map((row) => TransferSummary(
          totalReceived: row.read<double>('total_received'),
          totalPaid: row.read<double>('total_paid'),
          totalCommission: row.read<double>('total_commission'),
          totalCount: row.read<int>('total_count'),
          paidCount: row.read<int>('paid_count'),
        ));
  }

  Future<int> insertTransfer({
    required int accountId,
    required TransferType type,
    required double amount,
    required int commission,
    required DateTime date,
    String? note,
  }) {
    return into(transfers).insert(TransfersCompanion.insert(
      accountId: accountId,
      type: type,
      amount: amount,
      commission: Value(commission),
      date: date,
      note: Value(note),
    ));
  }

  Future<bool> updateTransfer({
    required int id,
    required double amount,
    required int commission,
    required DateTime date,
    String? note,
  }) {
    return update(transfers).replace(TransfersCompanion(
      id: Value(id),
      amount: Value(amount),
      commission: Value(commission),
      date: Value(date),
      note: Value(note),
    ));
  }

  Future<int> deleteTransfer(int id) {
    return (delete(transfers)..where((t) => t.id.equals(id))).go();
  }
}

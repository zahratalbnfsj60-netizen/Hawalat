import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../data/models/transfer_type.dart';   // ⬅️ السطر الجديد
import '../providers/database_provider.dart';
import '../providers/transfers_provider.dart';
import '../utils/constants.dart';
import '../utils/date_filter.dart';
import '../widgets/filter_bar.dart';
import '../widgets/transfer_list_tile.dart';
import 'transfer_form_screen.dart';

class PaidScreen extends ConsumerWidget {
  final int accountId;
  const PaidScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(paidTransfersProvider(accountId));
    final query = ref.watch(paidSearchQueryProvider);
    final filter = ref.watch(paidDateFilterProvider);

    return Scaffold(
      body: Column(
        children: [
          FilterBar(
            searchProvider: paidSearchQueryProvider,
            dateFilterProvider: paidDateFilterProvider,
            hint: 'بحث بالاسم أو الملاحظة...',
          ),
          Expanded(
            child: transfersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (all) {
                final list = _filter(all, query, filter);
                final totalAmount = list.fold<double>(0, (s, t) => s + t.amount);
                final totalCommission = list.fold<double>(0, (s, t) => s + t.commission);

                if (list.isEmpty) return const Center(child: Text('لا توجد حوالات مدفوعة'));

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.red.withOpacity(0.08),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _info('المدفوع', totalAmount, Colors.red),
                          _info('العمولات', totalCommission, Colors.green),
                          _info('العدد', list.length.toDouble(), Colors.blue, isCount: true),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, i) => TransferListTile(
                          transfer: list[i],
                          onEdit: () => _openForm(context, list[i]),
                          onDelete: () => _delete(ref, list[i].id),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _info(String label, double value, Color color, {bool isCount = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(isCount ? value.toInt().toString() : currencyFormat.format(value),
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  List<Transfer> _filter(List<Transfer> list, String query, DateFilter filter) {
    final start = filter.startDate;
    return list.where((t) {
      final matchQuery = query.isEmpty || (t.note?.toLowerCase().contains(query.toLowerCase()) ?? false);
      final matchDate = start == null || !t.date.isBefore(start);
      return matchQuery && matchDate;
    }).toList();
  }

  void _openForm(BuildContext context, Transfer? existing) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => TransferFormScreen(
        accountId: accountId,
        type: TransferType.paid,
        existing: existing,
      ),
    ));
  }

  Future<void> _delete(WidgetRef ref, int id) async {
    await ref.read(databaseProvider).transfersDao.deleteTransfer(id);
  }
}

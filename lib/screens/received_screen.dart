import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../providers/transfers_provider.dart';
import '../utils/constants.dart';
import '../utils/date_filter.dart';
import '../widgets/filter_bar.dart';
import '../widgets/transfer_list_tile.dart';
import '../providers/database_provider.dart';
import 'transfer_form_screen.dart';

class ReceivedScreen extends ConsumerWidget {
  final int accountId;
  const ReceivedScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(receivedTransfersProvider(accountId));
    final searchQuery = ref.watch(receivedSearchQueryProvider);
    final dateFilter = ref.watch(receivedDateFilterProvider);

    return Scaffold(
      body: Column(
        children: [
          FilterBar(
            searchProvider: receivedSearchQueryProvider,
            dateFilterProvider: receivedDateFilterProvider,
            hint: 'بحث بالاسم أو الملاحظة...',
          ),
          Expanded(
            child: transfersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (allTransfers) {
                final filtered = _filter(allTransfers, searchQuery, dateFilter);
                final total = filtered.fold<double>(0, (s, t) => s + t.amount);

                if (filtered.isEmpty) {
                  return const Center(child: Text('لا توجد حوالات مستلمة'));
                }

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.green.withOpacity(0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('إجمالي المستلم: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            currencyFormat.format(total),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final t = filtered[i];
                          return TransferListTile(
                            transfer: t,
                            onEdit: () => _openForm(context, ref, t),
                            onDelete: () => _delete(ref, t.id),
                          );
                        },
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
        onPressed: () => _openForm(context, ref, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Transfer> _filter(List<Transfer> list, String query, DateFilter filter) {
    final start = filter.startDate;
    return list.where((t) {
      final matchQuery = query.isEmpty ||
          (t.note?.toLowerCase().contains(query.toLowerCase()) ?? false);
      final matchDate = start == null || !t.date.isBefore(start);
      return matchQuery && matchDate;
    }).toList();
  }

  void _openForm(BuildContext context, WidgetRef ref, Transfer? existing) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransferFormScreen(
          accountId: accountId,
          type: TransferType.received,
          existing: existing,
        ),
      ),
    );
  }

  Future<void> _delete(WidgetRef ref, int id) async {
    final db = ref.read(databaseProvider);
    await db.transfersDao.deleteTransfer(id);
  }
}

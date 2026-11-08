import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transfers_provider.dart';
import '../utils/constants.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  final int accountId;
  const DashboardScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(summaryProvider(accountId));

    return Scaffold(
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (s) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SummaryCard(
                  title: 'الرصيد الصافي (الباقي)',
                  amount: s.netBalance,
                  icon: Icons.account_balance_wallet,
                  color: s.netBalance >= 0 ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 12),
                SummaryCard(
                  title: 'إجمالي الأرباح (العمولات)',
                  amount: s.totalCommission,
                  icon: Icons.trending_up,
                  color: Colors.teal,
                ),
                const SizedBox(height: 12),
                SummaryCard(
                  title: 'إجمالي المستلم',
                  amount: s.totalReceived,
                  icon: Icons.call_received,
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                SummaryCard(
                  title: 'إجمالي المدفوع',
                  amount: s.totalPaid,
                  icon: Icons.call_made,
                  color: Colors.red,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Icon(Icons.receipt_long, color: Colors.blue),
                              const SizedBox(height: 8),
                              Text('إجمالي الحوالات', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              Text('${s.totalCount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Icon(Icons.call_made, color: Colors.red),
                              const SizedBox(height: 8),
                              Text('الحوالات المدفوعة', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              Text('${s.paidCount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

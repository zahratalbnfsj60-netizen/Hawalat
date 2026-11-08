import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/accounts_provider.dart';
import '../providers/active_account_provider.dart';
import '../providers/database_provider.dart';

class AccountSwitcher extends ConsumerWidget {
  const AccountSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsStreamProvider);
    final activeId = ref.watch(activeAccountIdProvider);
    final activeName = accountsAsync.maybeWhen(
      data: (accounts) {
        final acc = accounts.where((a) => a.id == activeId).firstOrNull;
        return acc?.name ?? 'اختر حسابًا';
      },
      orElse: () => '...',
    );

    return InkWell(
      onTap: () => _showAccountSheet(context, ref),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(activeName, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  void _showAccountSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final accountsAsync = ref.watch(accountsStreamProvider);
            return accountsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (accounts) {
                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text('الحسابات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    ...accounts.map((acc) {
                      final isActive = ref.watch(activeAccountIdProvider) == acc.id;
                      return ListTile(
                        leading: Icon(
                          isActive ? Icons.check_circle : Icons.account_circle_outlined,
                          color: isActive ? Theme.of(context).colorScheme.primary : null,
                        ),
                        title: Text(acc.name),
                        onTap: () {
                          ref.read(activeAccountIdProvider.notifier).state = acc.id;
                          Navigator.pop(ctx);
                        },
                      );
                    }),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('إضافة حساب جديد'),
                      onTap: () {
                        Navigator.pop(ctx);
                        _showAddAccountDialog(context, ref);
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _showAddAccountDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حساب جديد'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'اسم الحساب',
            hintText: 'مثال: العمل، الدين، شخصي',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              final db = ref.read(databaseProvider);
              final id = await db.accountsDao.insertAccount(name);
              ref.read(activeAccountIdProvider.notifier).state = id;
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}

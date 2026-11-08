import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/accounts_provider.dart';
import '../providers/active_account_provider.dart';
import 'dashboard_screen.dart';
import 'paid_screen.dart';
import 'received_screen.dart';
import '../widgets/account_switcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsStreamProvider);
    final activeId = ref.watch(activeAccountIdProvider);

    // تعيين الحساب النشط تلقائيًا عند توفر الحسابات
    ref.listen(accountsStreamProvider, (previous, next) {
      next.whenData((accounts) {
        if (activeId == null && accounts.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(activeAccountIdProvider.notifier).state = accounts.first.id;
          });
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const AccountSwitcher(),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(accountsStreamProvider),
          ),
        ],
      ),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (accounts) {
          if (activeId == null) {
            return const Center(child: CircularProgressIndicator());
          }
          switch (_currentIndex) {
            case 0:
              return ReceivedScreen(accountId: activeId);
            case 1:
              return PaidScreen(accountId: activeId);
            case 2:
              return DashboardScreen(accountId: activeId);
            default:
              return ReceivedScreen(accountId: activeId);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.call_received), label: 'المستلم'),
          BottomNavigationBarItem(icon: Icon(Icons.call_made), label: 'المدفوع'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'الباقي والأرباح'),
        ],
      ),
    );
  }
}

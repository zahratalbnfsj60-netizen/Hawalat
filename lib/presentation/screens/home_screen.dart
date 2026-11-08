import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حـوالاتـي',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.security),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الإجمالي الفخمة
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.deepNavy, Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.royalGold.withOpacity(0.5), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'إجمالي الحوالات الشهرية',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.royalGold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.royalGold),
                        ),
                        child: const Text(
                          'محلي آمن 100%',
                          style: TextStyle(color: AppColors.royalGold, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '\$ 12,450.00',
                    style: TextStyle(
                      color: AppColors.royalGold,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(label: 'الصادرة', amount: '\$ 4,200', color: Colors.redAccent),
                      _StatItem(label: 'الواردة', amount: '\$ 8,250', color: Colors.greenAccent),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // رسم بياني تفاعلي
            const Text(
              'توزيع الحوالات حسب العملة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          color: AppColors.royalGold,
                          value: 55,
                          title: 'USD 55%',
                          radius: 50,
                          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        PieChartSectionData(
                          color: AppColors.deepNavy,
                          value: 30,
                          title: 'EUR 30%',
                          radius: 45,
                          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        PieChartSectionData(
                          color: Colors.amber.shade700,
                          value: 15,
                          title: 'SAR 15%',
                          radius: 40,
                          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // قائمة أحدث الحوالات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'أحدث الحوالات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('عرض الكل', style: TextStyle(color: AppColors.royalGold)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: index.isEven ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                      child: Icon(
                        index.isEven ? Icons.arrow_upward : Icons.arrow_downward,
                        color: index.isEven ? Colors.red : Colors.green,
                      ),
                    ),
                    title: Text(index.isEven ? 'محمود العلي' : 'شركة الأمل'),
                    subtitle: Text(index.isEven ? 'صادرة • 2026/11/08' : 'واردة • 2026/11/07'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${index.isEven ? '-' : '+'}\$${(index + 1) * 500}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: index.isEven ? Colors.red : Colors.green,
                          ),
                        ),
                        const Text('1 USD = 1.00', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.royalGold,
        foregroundColor: AppColors.deepNavy,
        icon: const Icon(Icons.add),
        label: const Text('تسجيل حوالة', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _StatItem({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
            Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ],
    );
  }
}

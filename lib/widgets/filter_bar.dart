import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/date_filter.dart';

class FilterBar extends ConsumerWidget {
  final StateProvider<String> searchProvider;
  final StateProvider<DateFilter> dateFilterProvider;
  final String hint;

  const FilterBar({
    super.key,
    required this.searchProvider,
    required this.dateFilterProvider,
    this.hint = 'بحث...',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFilter = ref.watch(dateFilterProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            onChanged: (v) => ref.read(searchProvider.notifier).state = v,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: DateFilter.values.map((f) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ChoiceChip(
                  label: Text(f.label),
                  selected: f == dateFilter,
                  onSelected: (_) => ref.read(dateFilterProvider.notifier).state = f,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

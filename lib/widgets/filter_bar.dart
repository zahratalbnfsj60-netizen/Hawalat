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
    final query = ref.watch(searchProvider);
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: DateFilter.values.map((f) {
              final selected = f == dateFilter;
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ChoiceChip(
                  label: Text(f.label),
                  selected: selected,
                  onSelected: (_) => ref.read(dateFilterProvider.notifier).state = f,
                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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

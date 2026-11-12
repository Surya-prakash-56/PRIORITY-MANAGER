import 'package:flutter/material.dart';
import '../models/priority_task.dart';
import '../utils/constants.dart';

class PriorityFilterBar extends StatelessWidget {
  final PriorityFilter activeFilter;
  final ValueChanged<PriorityFilter> onFilterSelected;
  final Map<PriorityFilter, int> counts;

  const PriorityFilterBar({
    super.key,
    required this.activeFilter,
    required this.onFilterSelected,
    required this.counts,
  });

  Color _getFilterColor(PriorityFilter filter) {
    return switch (filter) {
      PriorityFilter.urgent => AppColors.urgent,
      PriorityFilter.high => AppColors.high,
      PriorityFilter.medium => AppColors.medium,
      PriorityFilter.low => AppColors.low,
      PriorityFilter.completed => AppColors.low,
      PriorityFilter.pending => AppColors.high,
      PriorityFilter.all => AppColors.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: PriorityFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = PriorityFilter.values[index];
          final isSelected = filter == activeFilter;
          final color = _getFilterColor(filter);
          final count = counts[filter] ?? 0;

          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  filter.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.25)
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            selected: isSelected,
            selectedColor: color,
            backgroundColor: AppColors.surface,
            side: BorderSide(
              color: isSelected ? color : AppColors.border,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (_) => onFilterSelected(filter),
          );
        },
      ),
    );
  }
}

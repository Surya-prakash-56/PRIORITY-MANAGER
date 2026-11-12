import 'package:flutter/material.dart';
import '../models/priority_task.dart';

class PriorityBadge extends StatelessWidget {
  final PriorityLevel priority;
  final bool isDense;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.isDense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDense ? 8 : 10,
        vertical: isDense ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: priority.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: priority.color.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priority.icon,
            size: isDense ? 12 : 14,
            color: priority.color,
          ),
          const SizedBox(width: 4),
          Text(
            priority.label.toUpperCase(),
            style: TextStyle(
              fontSize: isDense ? 10 : 11,
              fontWeight: FontWeight.w700,
              color: priority.color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

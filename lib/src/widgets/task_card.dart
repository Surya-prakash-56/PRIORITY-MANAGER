import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/priority_task.dart';
import '../utils/constants.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final PriorityTask task;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      final hours = difference.inHours.abs();
      if (hours < 24) {
        return 'Overdue by ${hours == 0 ? "few minutes" : "$hours hrs"}';
      }
      return 'Overdue by ${difference.inDays.abs()} days';
    } else {
      if (difference.inHours < 1) {
        return 'Due in ${difference.inMinutes} mins';
      } else if (difference.inHours < 24) {
        return 'Due in ${difference.inHours} hrs';
      } else if (difference.inDays == 1) {
        return 'Due Tomorrow';
      } else if (difference.inDays < 7) {
        return 'Due in ${difference.inDays} days';
      }
      return 'Due ${DateFormat('MMM dd, yyyy').format(dueDate)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.urgent.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: task.isCompleted
              ? AppColors.surface.withOpacity(0.5)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: task.isCompleted
                ? AppColors.border.withOpacity(0.3)
                : task.priority == PriorityLevel.urgent
                    ? AppColors.urgent.withOpacity(0.5)
                    : AppColors.border,
            width: task.priority == PriorityLevel.urgent && !task.isCompleted ? 1.5 : 1,
          ),
          boxShadow: [
            if (!task.isCompleted)
              BoxShadow(
                color: task.priority.color.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Checkbox, Title, Priority Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Checkbox
                      Transform.scale(
                        scale: 1.1,
                        child: Checkbox(
                          value: task.isCompleted,
                          onChanged: onToggle,
                          activeColor: AppColors.primary,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          side: const BorderSide(color: AppColors.textSecondary, width: 1.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Title & Description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: task.isCompleted
                                    ? AppColors.textMuted
                                    : AppColors.textPrimary,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: AppColors.textMuted,
                              ),
                            ),
                            if (task.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: task.isCompleted
                                      ? AppColors.textMuted.withOpacity(0.7)
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      PriorityBadge(priority: task.priority, isDense: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 10),
                  // Footer Row: Category, Due Date, Effort, and Actions
                  Row(
                    children: [
                      // Category
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(task.category.icon, size: 13, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              task.category.label,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Estimated time
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_outlined, size: 13, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              '${task.estimatedMinutes}m',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Due date chip
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isOverdue ? Icons.warning_amber_rounded : Icons.calendar_today_rounded,
                            size: 13,
                            color: isOverdue ? AppColors.urgent : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDueDate(task.dueDate),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isOverdue ? FontWeight.w700 : FontWeight.w500,
                              color: isOverdue ? AppColors.urgent : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Edit icon button
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        color: AppColors.textSecondary,
                        tooltip: 'Edit Task',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: onEdit,
                      ),
                      // Delete icon button
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 16),
                        color: AppColors.urgent.withOpacity(0.8),
                        tooltip: 'Delete Task',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

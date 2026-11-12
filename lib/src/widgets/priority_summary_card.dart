import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PrioritySummaryCard extends StatelessWidget {
  final int totalCount;
  final int completedCount;
  final int urgentCount;
  final int highCount;
  final double completionRate;
  final VoidCallback? onClearCompleted;

  const PrioritySummaryCard({
    super.key,
    required this.totalCount,
    required this.completedCount,
    required this.urgentCount,
    required this.highCount,
    required this.completionRate,
    this.onClearCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (completionRate * 100).toInt();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E1E38),
            Color(0xFF161F38),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PRIORITY SUMMARY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryLight,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completedCount of $totalCount Tasks Completed',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryLight.withOpacity(0.5)),
                ),
                child: Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionRate,
              minHeight: 8,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage == 100
                    ? AppColors.low
                    : (percentage > 50 ? AppColors.accent : AppColors.primaryLight),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Priority Badges Load Indicator
          Row(
            children: [
              _buildLoadBadge(
                label: 'Urgent',
                count: urgentCount,
                color: AppColors.urgent,
                icon: Icons.error_outline_rounded,
              ),
              const SizedBox(width: 10),
              _buildLoadBadge(
                label: 'High Priority',
                count: highCount,
                color: AppColors.high,
                icon: Icons.warning_amber_rounded,
              ),
              const Spacer(),
              if (completedCount > 0 && onClearCompleted != null)
                TextButton.icon(
                  onPressed: onClearCompleted,
                  icon: const Icon(Icons.cleaning_services_rounded, size: 14, color: AppColors.textSecondary),
                  label: const Text(
                    'Clear Done',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadBadge({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

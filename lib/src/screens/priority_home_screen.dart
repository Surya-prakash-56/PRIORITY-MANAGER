import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/priority_controller.dart';
import '../models/priority_task.dart';
import '../utils/constants.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/priority_filter_bar.dart';
import '../widgets/priority_summary_card.dart';
import '../widgets/task_card.dart';

class PriorityHomeScreen extends StatefulWidget {
  const PriorityHomeScreen({super.key});

  @override
  State<PriorityHomeScreen> createState() => _PriorityHomeScreenState();
}

class _PriorityHomeScreenState extends State<PriorityHomeScreen> {
  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddTaskDialog([PriorityTask? taskToEdit]) {
    final controller = context.read<PriorityController>();
    showDialog(
      context: context,
      builder: (ctx) => AddTaskDialog(
        taskToEdit: taskToEdit,
        onSave: (task) {
          if (taskToEdit == null) {
            controller.addTask(task);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added "${task.title}" with ${task.priority.label} priority'),
                backgroundColor: task.priority.color,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          } else {
            controller.updateTask(task);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task updated successfully'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }

  void _handleDelete(PriorityTask task) {
    final controller = context.read<PriorityController>();
    final result = controller.deleteTask(task.id);
    if (result != null) {
      final (deletedTask, originalIndex) = result;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted "${deletedTask.title}"'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'UNDO',
            textColor: AppColors.accent,
            onPressed: () {
              controller.restoreTask(deletedTask, originalIndex);
            },
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PriorityController>();
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    final filterCounts = {
      PriorityFilter.all: controller.totalCount,
      PriorityFilter.urgent: controller.urgentCount,
      PriorityFilter.high: controller.highCount,
      PriorityFilter.medium: controller.mediumCount,
      PriorityFilter.low: controller.lowCount,
      PriorityFilter.pending: controller.pendingCount,
      PriorityFilter.completed: controller.completedCount,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppConstants.appTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${controller.pendingCount} pending · ${controller.urgentCount} urgent',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Search toggle
          IconButton(
            icon: Icon(
              _isSearchOpen ? Icons.close_rounded : Icons.search_rounded,
              color: AppColors.textSecondary,
            ),
            tooltip: _isSearchOpen ? 'Close Search' : 'Search Tasks',
            onPressed: () {
              setState(() {
                _isSearchOpen = !_isSearchOpen;
                if (!_isSearchOpen) {
                  _searchController.clear();
                  controller.setSearchQuery('');
                }
              });
            },
          ),
          // Sort Menu
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort_rounded, color: AppColors.textSecondary),
            tooltip: 'Sort Options',
            color: AppColors.surface,
            initialValue: controller.sortOption,
            onSelected: controller.setSortOption,
            itemBuilder: (context) {
              return SortOption.values.map((opt) {
                return PopupMenuItem(
                  value: opt,
                  child: Row(
                    children: [
                      Icon(
                        controller.sortOption == opt
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 16,
                        color: controller.sortOption == opt
                            ? AppColors.primaryLight
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        opt.label,
                        style: TextStyle(
                          color: controller.sortOption == opt
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontWeight: controller.sortOption == opt
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
          // Add Task Action Button on top bar for wider screens
          if (isDesktop) ...[
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _openAddTaskDialog(),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('New Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ],
      ),
      floatingActionButton: isDesktop
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openAddTaskDialog(),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text(
                'New Task',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
      body: isDesktop ? _buildDesktopLayout(controller, filterCounts) : _buildMobileLayout(controller, filterCounts),
    );
  }

  Widget _buildMobileLayout(PriorityController controller, Map<PriorityFilter, int> filterCounts) {
    return Column(
      children: [
        if (_isSearchOpen) _buildSearchBar(controller),
        PrioritySummaryCard(
          totalCount: controller.totalCount,
          completedCount: controller.completedCount,
          urgentCount: controller.urgentCount,
          highCount: controller.highCount,
          completionRate: controller.completionRate,
          onClearCompleted: controller.clearCompleted,
        ),
        const SizedBox(height: 6),
        PriorityFilterBar(
          activeFilter: controller.activeFilter,
          onFilterSelected: controller.setFilter,
          counts: filterCounts,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _buildTaskList(controller),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(PriorityController controller, Map<PriorityFilter, int> filterCounts) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar (Summary + Priority Matrix)
        SizedBox(
          width: 360,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrioritySummaryCard(
                  totalCount: controller.totalCount,
                  completedCount: controller.completedCount,
                  urgentCount: controller.urgentCount,
                  highCount: controller.highCount,
                  completionRate: controller.completionRate,
                  onClearCompleted: controller.clearCompleted,
                ),
                const SizedBox(height: 12),
                _buildPriorityMatrixCard(controller),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1, color: AppColors.border),
        // Main Task List Area
        Expanded(
          child: Column(
            children: [
              if (_isSearchOpen) _buildSearchBar(controller),
              const SizedBox(height: 12),
              PriorityFilterBar(
                activeFilter: controller.activeFilter,
                onFilterSelected: controller.setFilter,
                counts: filterCounts,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildTaskList(controller),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(PriorityController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surface,
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Filter by title, description or category...',
          hintStyle: const TextStyle(color: AppColors.textMuted),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryLight),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    controller.setSearchQuery('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
        onChanged: controller.setSearchQuery,
      ),
    );
  }

  Widget _buildPriorityMatrixCard(PriorityController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRIORITY BREAKDOWN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          _buildMatrixRow(PriorityLevel.urgent, controller.urgentCount),
          const SizedBox(height: 8),
          _buildMatrixRow(PriorityLevel.high, controller.highCount),
          const SizedBox(height: 8),
          _buildMatrixRow(PriorityLevel.medium, controller.mediumCount),
          const SizedBox(height: 8),
          _buildMatrixRow(PriorityLevel.low, controller.lowCount),
        ],
      ),
    );
  }

  Widget _buildMatrixRow(PriorityLevel level, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: level.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: level.color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(level.icon, size: 16, color: level.color),
          const SizedBox(width: 8),
          Text(
            level.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: level.color,
            ),
          ),
          const Spacer(),
          Text(
            '$count tasks',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: level.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(PriorityController controller) {
    final tasks = controller.filteredTasks;

    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.task_alt_rounded,
                  size: 52,
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Tasks in This View',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                controller.searchQuery.isNotEmpty
                    ? 'No matches for "${controller.searchQuery}".'
                    : 'All tasks under "${controller.activeFilter.label}" are organized.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 18),
              if (controller.activeFilter != PriorityFilter.all || controller.searchQuery.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () {
                    controller.setFilter(PriorityFilter.all);
                    controller.setSearchQuery('');
                    _searchController.clear();
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Reset Filters'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryLight,
                    side: const BorderSide(color: AppColors.primaryLight),
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: () => _openAddTaskDialog(),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add Your First Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onToggle: (_) => controller.toggleTaskStatus(task.id),
          onEdit: () => _openAddTaskDialog(task),
          onDelete: () => _handleDelete(task),
        );
      },
    );
  }
}

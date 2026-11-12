import 'package:flutter/foundation.dart';
import '../models/priority_task.dart';
import '../utils/constants.dart';

class PriorityController extends ChangeNotifier {
  final List<PriorityTask> _tasks = [];
  PriorityFilter _activeFilter = PriorityFilter.all;
  SortOption _sortOption = SortOption.priority;
  String _searchQuery = '';

  PriorityController({List<PriorityTask>? initialTasks}) {
    if (initialTasks != null) {
      _tasks.addAll(initialTasks);
    } else {
      _tasks.addAll(AppConstants.initialTasks);
    }
  }

  // Getters
  List<PriorityTask> get allTasks => List.unmodifiable(_tasks);
  PriorityFilter get activeFilter => _activeFilter;
  SortOption get sortOption => _sortOption;
  String get searchQuery => _searchQuery;

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  int get urgentCount => _tasks.where((t) => t.priority == PriorityLevel.urgent && !t.isCompleted).length;
  int get highCount => _tasks.where((t) => t.priority == PriorityLevel.high && !t.isCompleted).length;
  int get mediumCount => _tasks.where((t) => t.priority == PriorityLevel.medium && !t.isCompleted).length;
  int get lowCount => _tasks.where((t) => t.priority == PriorityLevel.low && !t.isCompleted).length;

  double get completionRate {
    if (_tasks.isEmpty) return 0.0;
    return completedCount / totalCount;
  }

  List<PriorityTask> get filteredTasks {
    var result = _tasks.where((task) {
      // Search matching
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = task.title.toLowerCase().contains(q);
        final matchesDesc = task.description.toLowerCase().contains(q);
        final matchesCategory = task.category.label.toLowerCase().contains(q);
        if (!matchesTitle && !matchesDesc && !matchesCategory) {
          return false;
        }
      }

      // Filter matching
      switch (_activeFilter) {
        case PriorityFilter.all:
          return true;
        case PriorityFilter.urgent:
          return task.priority == PriorityLevel.urgent;
        case PriorityFilter.high:
          return task.priority == PriorityLevel.high;
        case PriorityFilter.medium:
          return task.priority == PriorityLevel.medium;
        case PriorityFilter.low:
          return task.priority == PriorityLevel.low;
        case PriorityFilter.pending:
          return !task.isCompleted;
        case PriorityFilter.completed:
          return task.isCompleted;
      }
    }).toList();

    // Sorting
    switch (_sortOption) {
      case SortOption.priority:
        result.sort((a, b) {
          if (a.isCompleted != b.isCompleted) {
            return a.isCompleted ? 1 : -1;
          }
          final comp = a.priority.order.compareTo(b.priority.order);
          if (comp != 0) return comp;
          return a.dueDate.compareTo(b.dueDate);
        });
        break;
      case SortOption.dueDate:
        result.sort((a, b) {
          if (a.isCompleted != b.isCompleted) {
            return a.isCompleted ? 1 : -1;
          }
          return a.dueDate.compareTo(b.dueDate);
        });
        break;
      case SortOption.title:
        result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortOption.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return result;
  }

  // Mutations
  void addTask(PriorityTask task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void updateTask(PriorityTask updated) {
    final idx = _tasks.indexWhere((t) => t.id == updated.id);
    if (idx != -1) {
      _tasks[idx] = updated;
      notifyListeners();
    }
  }

  void toggleTaskStatus(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      final task = _tasks[idx];
      _tasks[idx] = task.copyWith(isCompleted: !task.isCompleted);
      notifyListeners();
    }
  }

  (PriorityTask, int)? deleteTask(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      final removed = _tasks.removeAt(idx);
      notifyListeners();
      return (removed, idx);
    }
    return null;
  }

  void restoreTask(PriorityTask task, int originalIndex) {
    final safeIndex = originalIndex.clamp(0, _tasks.length);
    _tasks.insert(safeIndex, task);
    notifyListeners();
  }

  void clearCompleted() {
    _tasks.removeWhere((t) => t.isCompleted);
    notifyListeners();
  }

  void setFilter(PriorityFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}

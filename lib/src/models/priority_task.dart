import 'package:flutter/material.dart';

enum PriorityLevel {
  urgent('Urgent', 1, Color(0xFFEF4444), Icons.priority_high_rounded),
  high('High', 2, Color(0xFFF59E0B), Icons.arrow_upward_rounded),
  medium('Medium', 3, Color(0xFF3B82F6), Icons.remove_rounded),
  low('Low', 4, Color(0xFF10B981), Icons.arrow_downward_rounded);

  final String label;
  final int order;
  final Color color;
  final IconData icon;

  const PriorityLevel(this.label, this.order, this.color, this.icon);
}

enum TaskCategory {
  work('Work', Icons.business_center_rounded),
  study('Study', Icons.menu_book_rounded),
  personal('Personal', Icons.person_rounded),
  health('Health', Icons.fitness_center_rounded),
  finance('Finance', Icons.account_balance_wallet_rounded);

  final String label;
  final IconData icon;

  const TaskCategory(this.label, this.icon);
}

enum PriorityFilter {
  all('All'),
  urgent('Urgent'),
  high('High'),
  medium('Medium'),
  low('Low'),
  pending('Pending'),
  completed('Completed');

  final String label;
  const PriorityFilter(this.label);
}

enum SortOption {
  priority('Priority (High to Low)'),
  dueDate('Due Date (Earliest)'),
  title('Title (A-Z)'),
  newest('Recently Added');

  final String label;
  const SortOption(this.label);
}

class PriorityTask {
  final String id;
  final String title;
  final String description;
  final PriorityLevel priority;
  final TaskCategory category;
  final DateTime dueDate;
  final bool isCompleted;
  final int estimatedMinutes;
  final DateTime createdAt;

  const PriorityTask({
    required this.id,
    required this.title,
    this.description = '',
    required this.priority,
    this.category = TaskCategory.work,
    required this.dueDate,
    this.isCompleted = false,
    this.estimatedMinutes = 30,
    required this.createdAt,
  });

  /// Priority score based on priority tier and proximity to due date
  double get priorityScore {
    final weight = switch (priority) {
      PriorityLevel.urgent => 4.0,
      PriorityLevel.high => 3.0,
      PriorityLevel.medium => 2.0,
      PriorityLevel.low => 1.0,
    };
    final now = DateTime.now();
    final hoursRemaining = dueDate.difference(now).inHours;
    final urgencyBonus = hoursRemaining <= 24 ? 2.0 : (hoursRemaining <= 72 ? 1.0 : 0.0);
    return weight * 2 + urgencyBonus;
  }

  PriorityTask copyWith({
    String? id,
    String? title,
    String? description,
    PriorityLevel? priority,
    TaskCategory? category,
    DateTime? dueDate,
    bool? isCompleted,
    int? estimatedMinutes,
    DateTime? createdAt,
  }) {
    return PriorityTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'category': category.name,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'estimatedMinutes': estimatedMinutes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PriorityTask.fromJson(Map<String, dynamic> json) {
    return PriorityTask(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      priority: PriorityLevel.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => PriorityLevel.medium,
      ),
      category: TaskCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => TaskCategory.work,
      ),
      dueDate: DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 30,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

import 'package:flutter/foundation.dart';

// Experiment 5 Provider Model
// Implements a reactive ChangeNotifier for task priority state management.

class PriorityTaskItem {
  final String id;
  final String title;
  final String tier;
  final bool isDone;

  const PriorityTaskItem({
    required this.id,
    required this.title,
    required this.tier,
    this.isDone = false,
  });

  PriorityTaskItem copyWith({bool? isDone}) {
    return PriorityTaskItem(
      id: id,
      title: title,
      tier: tier,
      isDone: isDone ?? this.isDone,
    );
  }
}

class PriorityProvider extends ChangeNotifier {
  final List<PriorityTaskItem> _items = [
    const PriorityTaskItem(id: '1', title: 'Submit College Lab Record', tier: 'Urgent'),
    const PriorityTaskItem(id: '2', title: 'Code Review Authentication PR', tier: 'High'),
    const PriorityTaskItem(id: '3', title: 'Design Weekly Meal Plan', tier: 'Low'),
  ];

  List<PriorityTaskItem> get items => List.unmodifiable(_items);
  int get totalCount => _items.length;
  int get completedCount => _items.where((t) => t.isDone).length;
  int get urgentCount => _items.where((t) => t.tier == 'Urgent' && !t.isDone).length;

  void toggleDone(String id) {
    final idx = _items.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _items[idx] = _items[idx].copyWith(isDone: !_items[idx].isDone);
      notifyListeners();
    }
  }

  void addItem(String title, String tier) {
    _items.insert(
      0,
      PriorityTaskItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        tier: tier,
      ),
    );
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

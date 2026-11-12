import 'package:flutter/material.dart';
import '../models/priority_task.dart';

class AppColors {
  // Primary dark background palette
  static const Color background = Color(0xFF0F172A); // Slate 900
  static const Color surface = Color(0xFF1E293B);    // Slate 800
  static const Color surfaceLight = Color(0xFF334155); // Slate 700
  static const Color cardBg = Color(0xFF1E293B);
  
  // Accents
  static const Color primary = Color(0xFF6366F1);   // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color accent = Color(0xFF06B6D4);    // Cyan
  
  // Priority Colors
  static const Color urgent = Color(0xFFEF4444);    // Red 500
  static const Color high = Color(0xFFF59E0B);      // Amber 500
  static const Color medium = Color(0xFF3B82F6);    // Blue 500
  static const Color low = Color(0xFF10B981);       // Emerald 500

  // Neutral text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color border = Color(0xFF334155);
}

class AppConstants {
  static const String appTitle = 'PRIORITY-MANAGER';
  static const String appSubtitle = 'Intelligent Cross-Platform Task & Urgency Organizer';

  static List<PriorityTask> get initialTasks {
    final now = DateTime.now();
    return [
      PriorityTask(
        id: '1',
        title: 'Submit College Flutter Lab Report',
        description: 'Complete Experiment 10 documentation, export SVG diagrams, and commit to GitHub.',
        priority: PriorityLevel.urgent,
        category: TaskCategory.study,
        dueDate: now.add(const Duration(hours: 4)),
        isCompleted: false,
        estimatedMinutes: 45,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      PriorityTask(
        id: '2',
        title: 'Review System Architecture PR #42',
        description: 'Check widget test coverage, Provider state decoupling, and responsive layouts.',
        priority: PriorityLevel.high,
        category: TaskCategory.work,
        dueDate: now.add(const Duration(days: 1)),
        isCompleted: false,
        estimatedMinutes: 60,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      PriorityTask(
        id: '3',
        title: 'Prepare Sprint Retrospective Notes',
        description: 'Aggregate team velocity metrics and blockers encountered during Milestone 2.',
        priority: PriorityLevel.medium,
        category: TaskCategory.work,
        dueDate: now.add(const Duration(days: 2)),
        isCompleted: true,
        estimatedMinutes: 30,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      PriorityTask(
        id: '4',
        title: 'Weekly Gym & Core Workout',
        description: 'Leg press, 5k treadmill run, stretching, and hydration check.',
        priority: PriorityLevel.medium,
        category: TaskCategory.health,
        dueDate: now.add(const Duration(hours: 18)),
        isCompleted: false,
        estimatedMinutes: 50,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      PriorityTask(
        id: '5',
        title: 'Audit Monthly Cloud Subscriptions',
        description: 'Cancel unused test instances and review AWS/GCP billing alerts.',
        priority: PriorityLevel.low,
        category: TaskCategory.finance,
        dueDate: now.add(const Duration(days: 5)),
        isCompleted: false,
        estimatedMinutes: 20,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }
}

// Experiment 1: Dart Basics
// Demonstrates Dart primitive types, enums, arithmetic operators, string interpolation,
// and conditional decision statements for task priority calculations and urgency scoring.

enum PriorityTier { urgent, high, medium, low }

void main(List<String> args) {
  // 1. Variable declarations with strong types
  const String appName = 'PRIORITY-MANAGER';
  const String userRole = 'Sprint Lead / Tech Architect';
  int totalTasks = args.isNotEmpty ? int.tryParse(args[0]) ?? 18 : 18;
  int completedTasks = args.length > 1 ? int.tryParse(args[1]) ?? 12 : 12;
  int urgentTasks = 4;
  int highTasks = 6;
  bool isSprintOnTrack = (completedTasks / totalTasks) >= 0.60;

  // 2. Arithmetic & statistical metrics
  int pendingTasks = totalTasks - completedTasks;
  double completionPercentage = (completedTasks / totalTasks) * 100;
  double urgentRatio = (urgentTasks / totalTasks) * 100;

  print('==============================================');
  print('          $appName — METRICS ENGINE           ');
  print('==============================================');
  print('Role: $userRole');
  print('Total Tracked Tasks: $totalTasks');
  print('Completed: $completedTasks | Pending: $pendingTasks');
  print('Completion Rate: ${completionPercentage.toStringAsFixed(1)}%');
  print('Urgent Load: $urgentTasks (${urgentRatio.toStringAsFixed(1)}%) | High Load: $highTasks');
  print('----------------------------------------------');

  // 3. Conditional evaluation of workload urgency
  if (urgentTasks >= 5) {
    print('Workload Alert: CRITICAL OVERLOAD (Immediate triage required)');
  } else if (urgentTasks >= 3) {
    print('Workload Alert: ELEVATED PRESSURE (Prioritize P1 items first)');
  } else {
    print('Workload Alert: BALANCED FLOW (Healthy task distribution)');
  }

  // 4. Urgency score calculation formula
  double calculateUrgencyScore(PriorityTier tier, int hoursRemaining) {
    final baseWeight = switch (tier) {
      PriorityTier.urgent => 40.0,
      PriorityTier.high => 30.0,
      PriorityTier.medium => 20.0,
      PriorityTier.low => 10.0,
    };
    final deadlineFactor = hoursRemaining <= 12 ? 2.5 : (hoursRemaining <= 48 ? 1.5 : 1.0);
    return baseWeight * deadlineFactor;
  }

  final score1 = calculateUrgencyScore(PriorityTier.urgent, 6);
  final score2 = calculateUrgencyScore(PriorityTier.medium, 72);

  print('Calculated Urgency Score (Urgent, 6h left): $score1');
  print('Calculated Urgency Score (Medium, 72h left): $score2');

  // 5. Ternary status check
  final sprintStatus = isSprintOnTrack
      ? 'Sprint is ON TRACK for scheduled release.'
      : 'Sprint is BEHIND SCHEDULE. Reallocation needed.';
  print('Sprint Status: $sprintStatus');
  print('==============================================');
}

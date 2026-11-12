import 'package:flutter/material.dart';

// Experiment 10: Testing and Debugging in Flutter
// Demonstrates Flutter unit testing assertions, widget testing concepts,
// and debugging tools (Flutter Inspector, DevTools, debugPrint logging, breakpoints).

void main() {
  runApp(const TestingDebuggingPriorityApp());
}

class TestingDebuggingPriorityApp extends StatelessWidget {
  const TestingDebuggingPriorityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Experiment 10 - Testing & Debugging',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const TestingDashboardScreen(),
    );
  }
}

class TestingDashboardScreen extends StatefulWidget {
  const TestingDashboardScreen({super.key});

  @override
  State<TestingDashboardScreen> createState() => _TestingDashboardScreenState();
}

class _TestingDashboardScreenState extends State<TestingDashboardScreen> {
  final List<String> _logs = [];

  void _runSelfDiagnostics() {
    setState(() {
      _logs.clear();
      _log('Initializing Priority-Manager Diagnostics Suite...');

      // Test 1: Priority score assertion
      const urgentWeight = 4.0;
      const hoursRemaining = 6;
      const urgencyBonus = hoursRemaining <= 12 ? 2.0 : 0.0;
      const score = urgentWeight * 2 + urgencyBonus;
      assert(score == 10.0, 'Priority score calculation mismatch');
      _log('✓ Assertion Passed: Urgent Task Priority Score = $score (expected 10.0)');

      // Test 2: Completion percentage calculation
      const total = 20;
      const completed = 15;
      const rate = (completed / total) * 100;
      assert(rate == 75.0, 'Completion rate mismatch');
      _log('✓ Assertion Passed: Completion Rate = $rate% (expected 75.0%)');

      // Test 3: Null safety & boundary verification
      const List<String> taskIds = ['T1', 'T2', 'T3'];
      assert(taskIds.isNotEmpty, 'Task queue cannot be empty');
      _log('✓ Assertion Passed: Task Queue boundary verified (length: ${taskIds.length})');

      _log('All 3 automated inline assertions PASSED successfully.');
    });
  }

  void _log(String message) {
    _logs.add(message);
    debugPrint('[PRIORITY_DEBUG]: $message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Exp 10: Testing & Debugging'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.4)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DEBUGGING CHECKLIST', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF818CF8))),
                  SizedBox(height: 8),
                  Text('• Run "flutter test" to execute unit & widget test suites', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                  Text('• Use Flutter DevTools (Memory, CPU Profiler, Network)', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                  Text('• Inspect widget tree with Flutter Inspector in VS Code / IDE', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                  Text('• Utilize debugPrint() to avoid log truncation in production', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _runSelfDiagnostics,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Run Diagnostics & Assertions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: _logs.isEmpty
                    ? const Center(
                        child: Text(
                          'Press "Run Diagnostics" to execute test assertions.',
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _logs.length,
                        itemBuilder: (ctx, i) {
                          final log = _logs[i];
                          final isPass = log.startsWith('✓');
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Text(
                              log,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: isPass ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

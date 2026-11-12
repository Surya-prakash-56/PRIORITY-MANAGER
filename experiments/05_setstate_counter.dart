import 'package:flutter/material.dart';

// Experiment 5 (Local State): StatefulWidget and setState()
// Contrasts local component state accumulation against decoupled reactive state management.

void main() {
  runApp(const SetStatePriorityApp());
}

class SetStatePriorityApp extends StatelessWidget {
  const SetStatePriorityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Experiment 5 - setState Counter',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const SetStatePriorityScreen(),
    );
  }
}

class SetStatePriorityScreen extends StatefulWidget {
  const SetStatePriorityScreen({super.key});

  @override
  State<SetStatePriorityScreen> createState() => _SetStatePriorityScreenState();
}

class _SetStatePriorityScreenState extends State<SetStatePriorityScreen> {
  int _completedTasks = 5;
  int _urgentTasks = 2;

  void _incrementCompleted() {
    setState(() {
      _completedTasks++;
    });
  }

  void _resolveUrgentTask() {
    setState(() {
      if (_urgentTasks > 0) {
        _urgentTasks--;
        _completedTasks++;
      }
    });
  }

  void _resetCounters() {
    setState(() {
      _completedTasks = 0;
      _urgentTasks = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Exp 5: Local setState() State'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  children: [
                    const Text('Completed Tasks (setState)', style: TextStyle(color: Color(0xFF94A3B8))),
                    const SizedBox(height: 8),
                    Text(
                      '$_completedTasks',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                    ),
                    const Divider(color: Color(0xFF334155), height: 32),
                    const Text('Pending Urgent Tasks', style: TextStyle(color: Color(0xFF94A3B8))),
                    const SizedBox(height: 8),
                    Text(
                      '$_urgentTasks',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _incrementCompleted,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Complete Task'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _resolveUrgentTask,
                    icon: const Icon(Icons.flash_on_rounded),
                    label: const Text('Resolve Urgent'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _resetCounters,
                child: const Text('Reset Counters', style: TextStyle(color: Color(0xFF94A3B8))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

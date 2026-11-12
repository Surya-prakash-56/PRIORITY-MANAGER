import 'package:flutter/material.dart';

// Experiment 8: Animations
// Leverages Flutter's animation framework using AnimationController, CurvedAnimation,
// FadeTransition, ScaleTransition, and SlideTransition to animate task priority resolution.

void main() {
  runApp(const PriorityAnimationApp());
}

class PriorityAnimationApp extends StatelessWidget {
  const PriorityAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Experiment 8 - Animations',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const AnimatedPriorityScreen(),
    );
  }
}

class AnimatedPriorityScreen extends StatefulWidget {
  const AnimatedPriorityScreen({super.key});

  @override
  State<AnimatedPriorityScreen> createState() => _AnimatedPriorityScreenState();
}

class _AnimatedPriorityScreenState extends State<AnimatedPriorityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isTaskDone = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerCelebration() {
    setState(() {
      _isTaskDone = !_isTaskDone;
    });
    if (_isTaskDone) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Exp 8: Transitions & Physics'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isTaskDone
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isTaskDone
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444))
                              .withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isTaskDone ? Icons.task_alt_rounded : Icons.priority_high_rounded,
                          size: 54,
                          color: _isTaskDone ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isTaskDone ? 'Task Accomplished!' : 'Urgent Production Deployment',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isTaskDone
                              ? 'Priority queue item cleared with high impact.'
                              : 'Due within 45 minutes · Critical tier',
                          style: const TextStyle(color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _fadeAnimation,
                child: ElevatedButton.icon(
                  onPressed: _triggerCelebration,
                  icon: Icon(_isTaskDone ? Icons.replay_rounded : Icons.check_circle_rounded),
                  label: Text(_isTaskDone ? 'Reset Animation' : 'Mark Completed (Animate)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isTaskDone ? const Color(0xFF334155) : const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

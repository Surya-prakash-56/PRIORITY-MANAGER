import 'package:flutter/material.dart';

// Experiment 4: Navigation and Named Routes
// Demonstrates multi-screen navigation using Navigator.pushNamed(), route arguments,
// and stack popping between Dashboard ('/'), Task Details ('/details'), and Analytics ('/analytics').

void main() {
  runApp(const PriorityNavigationApp());
}

class PriorityNavigationApp extends StatelessWidget {
  const PriorityNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Experiment 4 - Navigation',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/details': (context) => const TaskDetailScreen(),
        '/analytics': (context) => const AnalyticsScreen(),
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Priority Dashboard (Route: /)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'View Analytics',
            onPressed: () => Navigator.pushNamed(context, '/analytics'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'SELECT A TASK TO INSPECT DETAILS:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 12),
          _buildNavTile(
            context,
            title: 'Refactor Payment Microservice',
            tier: 'Urgent',
            color: const Color(0xFFEF4444),
            desc: 'Fix race condition during concurrent webhook processing.',
          ),
          _buildNavTile(
            context,
            title: 'Design Dark Mode Design System',
            tier: 'High',
            color: const Color(0xFFF59E0B),
            desc: 'Standardize tokens and elevation palettes across Flutter widgets.',
          ),
          _buildNavTile(
            context,
            title: 'Weekly Backlog Grooming',
            tier: 'Medium',
            color: const Color(0xFF3B82F6),
            desc: 'Estimate user stories for sprint 24 with engineering team.',
          ),
        ],
      ),
    );
  }

  static Widget _buildNavTile(
    BuildContext context, {
    required String title,
    required String tier,
    required Color color,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF8FAFC))),
        subtitle: Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/details',
            arguments: {'title': title, 'tier': tier, 'desc': desc},
          );
        },
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final title = args['title'] as String? ?? 'Unknown Task';
    final tier = args['tier'] as String? ?? 'Medium';
    final desc = args['desc'] as String? ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Task Details (/details)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('PRIORITY: $tier', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF818CF8))),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFF8FAFC))),
            const SizedBox(height: 12),
            Text(desc, style: const TextStyle(fontSize: 15, color: Color(0xFF94A3B8))),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Back to Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Priority Analytics (/analytics)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Burndown & Velocity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('• 75% of urgent tasks completed within 24h SLA', style: TextStyle(color: Color(0xFF94A3B8))),
            const Text('• Average time-to-close on high-priority tickets: 4.2 hours', style: TextStyle(color: Color(0xFF94A3B8))),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// Experiment 6: Custom Widgets and Themes
// Constructs modular reusable custom widgets (PriorityHeader, PriorityCard, UrgencyIndicator)
// and demonstrates dynamic theme switching between Light and Dark ThemeData.

void main() {
  runApp(const CustomWidgetsThemesApp());
}

class CustomWidgetsThemesApp extends StatefulWidget {
  const CustomWidgetsThemesApp({super.key});

  @override
  State<CustomWidgetsThemesApp> createState() => _CustomWidgetsThemesAppState();
}

class _CustomWidgetsThemesAppState extends State<CustomWidgetsThemesApp> {
  bool _isDark = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Experiment 6 - Custom Widgets & Themes',
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: CustomWidgetsThemesScreen(
        isDark: _isDark,
        onToggleTheme: () => setState(() => _isDark = !_isDark),
      ),
    );
  }
}

class CustomWidgetsThemesScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const CustomWidgetsThemesScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exp 6: Custom Widgets & Themes'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            tooltip: 'Toggle Theme',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          PriorityHeaderWidget(
            title: 'Q4 Product Roadmap Delivery',
            subtitle: 'Critical deliverables assigned to engineering pods',
          ),
          SizedBox(height: 16),
          PriorityCustomCard(
            title: 'Payment Gateway Stripe Integration',
            category: 'Engineering',
            tier: 'Urgent',
            color: Color(0xFFEF4444),
          ),
          SizedBox(height: 12),
          PriorityCustomCard(
            title: 'Design Design System Tokens in Figma',
            category: 'UI/UX',
            tier: 'High',
            color: Color(0xFFF59E0B),
          ),
          SizedBox(height: 12),
          PriorityCustomCard(
            title: 'Weekly Knowledge Sharing Presentation',
            category: 'Team',
            tier: 'Medium',
            color: Color(0xFF3B82F6),
          ),
        ],
      ),
    );
  }
}

// Custom Reusable Widget 1: PriorityHeaderWidget
class PriorityHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const PriorityHeaderWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
        ],
      ),
    );
  }
}

// Custom Reusable Widget 2: PriorityCustomCard
class PriorityCustomCard extends StatelessWidget {
  final String title;
  final String category;
  final String tier;
  final Color color;

  const PriorityCustomCard({
    super.key,
    required this.title,
    required this.category,
    required this.tier,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 6, backgroundColor: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(category, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(tier, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

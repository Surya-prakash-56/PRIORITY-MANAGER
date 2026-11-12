import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_provider.dart';

// Experiment 5: Reactive State Management with Provider
// Demonstrates decoupling business state from the UI using ChangeNotifierProvider,
// notifyListeners(), and Consumer for real-time task completion and priority metrics.

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PriorityProvider(),
      child: const ProviderPriorityApp(),
    ),
  );
}

class ProviderPriorityApp extends StatelessWidget {
  const ProviderPriorityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Experiment 5 - Provider State Management',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const ProviderPriorityScreen(),
    );
  }
}

class ProviderPriorityScreen extends StatelessWidget {
  const ProviderPriorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Exp 5: Provider State Management'),
      ),
      body: Consumer<PriorityProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('Total', '${provider.totalCount}', const Color(0xFF818CF8)),
                    _buildStat('Done', '${provider.completedCount}', const Color(0xFF10B981)),
                    _buildStat('Urgent', '${provider.urgentCount}', const Color(0xFFEF4444)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.items.length,
                  itemBuilder: (ctx, i) {
                    final item = provider.items[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: item.isDone,
                          onChanged: (_) => provider.toggleDone(item.id),
                          activeColor: const Color(0xFF6366F1),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            decoration: item.isDone ? TextDecoration.lineThrough : null,
                            color: item.isDone ? const Color(0xFF64748B) : Colors.white,
                          ),
                        ),
                        trailing: Text(
                          item.tier,
                          style: TextStyle(
                            color: item.tier == 'Urgent'
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFF59E0B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PriorityProvider>().addItem(
            'New Task #${DateTime.now().second}',
            'Urgent',
          );
        },
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  static Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
      ],
    );
  }
}

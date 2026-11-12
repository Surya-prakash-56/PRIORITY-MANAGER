import 'package:flutter/material.dart';

// Experiment 3: Responsive UI
// Uses MediaQuery and adaptive breakpoints (<600px mobile, 600-1000px tablet, >1000px desktop)
// to dynamically switch between a single-column list, responsive grid, and dual-pane Eisenhower matrix.

void main() {
  runApp(const ResponsivePriorityApp());
}

class ResponsivePriorityApp extends StatelessWidget {
  const ResponsivePriorityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Experiment 3 - Responsive UI',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const ResponsivePriorityScreen(),
    );
  }
}

class ResponsivePriorityScreen extends StatelessWidget {
  const ResponsivePriorityScreen({super.key});

  static const List<Map<String, dynamic>> dummyTasks = [
    {'title': 'Fix Memory Leak in Production', 'tier': 'Urgent', 'color': Color(0xFFEF4444)},
    {'title': 'Design Database Schema for v2', 'tier': 'High', 'color': Color(0xFFF59E0B)},
    {'title': 'Team Standup & Daily Sync', 'tier': 'Medium', 'color': Color(0xFF3B82F6)},
    {'title': 'Update Documentation Links', 'tier': 'Low', 'color': Color(0xFF10B981)},
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1000;
    final isTablet = width >= 600 && width < 1000;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          isDesktop ? 'Desktop View (Dual-Pane)' : (isTablet ? 'Tablet View (2-Column Grid)' : 'Mobile View (Single-Column)'),
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1000) {
            // Desktop Dual-Pane
            return Row(
              children: [
                Container(
                  width: 320,
                  color: const Color(0xFF1E293B),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EISENHOWER MATRIX',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF818CF8)),
                      ),
                      const SizedBox(height: 16),
                      _buildMatrixItem('Urgent & Important (Do First)', 3, const Color(0xFFEF4444)),
                      const SizedBox(height: 10),
                      _buildMatrixItem('Not Urgent & Important (Schedule)', 5, const Color(0xFFF59E0B)),
                      const SizedBox(height: 10),
                      _buildMatrixItem('Urgent & Not Important (Delegate)', 4, const Color(0xFF3B82F6)),
                      const SizedBox(height: 10),
                      _buildMatrixItem('Not Urgent & Not Important (Eliminate)', 2, const Color(0xFF10B981)),
                    ],
                  ),
                ),
                Expanded(child: _buildTaskList()),
              ],
            );
          } else if (constraints.maxWidth >= 600) {
            // Tablet 2-Column Grid
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: dummyTasks.length,
              itemBuilder: (ctx, i) => _buildCard(dummyTasks[i]),
            );
          } else {
            // Mobile Single-Column
            return _buildTaskList();
          }
        },
      ),
    );
  }

  static Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyTasks.length,
      itemBuilder: (ctx, i) => _buildCard(dummyTasks[i]),
    );
  }

  static Widget _buildCard(Map<String, dynamic> item) {
    final color = item['color'] as Color;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 6, backgroundColor: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFF8FAFC)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item['tier'] as String,
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildMatrixItem(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: TextStyle(fontSize: 12, color: color))),
          Text('$count', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

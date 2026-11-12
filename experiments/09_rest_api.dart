import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Experiment 9: REST API Integration
// Fetches remote tasks from an open REST API (JSONPlaceholder todos) using HTTP GET,
// deserializing JSON into Dart models, and rendering with FutureBuilder, loading spinners, and error retry states.

void main() {
  runApp(const RestApiPriorityApp());
}

class RestApiPriorityApp extends StatelessWidget {
  const RestApiPriorityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Experiment 9 - REST API',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const RemoteTasksScreen(),
    );
  }
}

class RemoteTaskModel {
  final int id;
  final String title;
  final bool completed;

  const RemoteTaskModel({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory RemoteTaskModel.fromJson(Map<String, dynamic> json) {
    return RemoteTaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }
}

class RemoteTasksScreen extends StatefulWidget {
  const RemoteTasksScreen({super.key});

  @override
  State<RemoteTasksScreen> createState() => _RemoteTasksScreenState();
}

class _RemoteTasksScreenState extends State<RemoteTasksScreen> {
  late Future<List<RemoteTaskModel>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _fetchRemoteTasks();
  }

  Future<List<RemoteTaskModel>> _fetchRemoteTasks() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos?_limit=10'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((e) => RemoteTaskModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load tasks from server (${response.statusCode})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Exp 9: REST API Integration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reload Tasks',
            onPressed: () {
              setState(() {
                _tasksFuture = _fetchRemoteTasks();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<RemoteTaskModel>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF6366F1)),
                  SizedBox(height: 16),
                  Text('Fetching tasks from remote API...', style: TextStyle(color: Color(0xFF94A3B8))),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 48, color: Color(0xFFEF4444)),
                    const SizedBox(height: 12),
                    Text(
                      'API Request Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFEF4444)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() => _tasksFuture = _fetchRemoteTasks()),
                      child: const Text('Retry Connection'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No remote tasks received.'));
          }

          final tasks = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (ctx, i) {
              final task = tasks[i];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: task.completed ? const Color(0xFF10B981).withOpacity(0.3) : const Color(0xFF334155),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: task.completed ? const Color(0xFF10B981) : const Color(0xFF6366F1),
                    radius: 14,
                    child: Text('${task.id}', style: const TextStyle(fontSize: 11, color: Colors.white)),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: task.completed ? const Color(0xFF94A3B8) : Colors.white,
                      decoration: task.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: (task.completed ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.completed ? 'RESOLVED' : 'SYNCED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: task.completed ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

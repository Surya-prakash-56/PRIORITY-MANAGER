import 'package:flutter/material.dart';

// Experiment 7: Forms, Validation, and User Feedback
// Demonstrates Form, GlobalKey<FormState>, TextFormField, dropdown validation,
// and SnackBar alert feedback for creating validated priority tasks.

void main() {
  runApp(const FormsValidationPriorityApp());
}

class FormsValidationPriorityApp extends StatelessWidget {
  const FormsValidationPriorityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Experiment 7 - Forms & Validation',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const TaskFormScreen(),
    );
  }
}

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _minutesController = TextEditingController(text: '30');
  String _selectedTier = 'Urgent';

  @override
  void dispose() {
    _titleController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final minutes = int.parse(_minutesController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "$title" ($minutes mins, $_selectedTier) created successfully!'),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _titleController.clear();
      _minutesController.text = '30';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please resolve validation errors before submitting.'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Exp 7: Forms & Validation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Priority Task Form', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('All fields marked with * are strictly validated.', style: TextStyle(color: Color(0xFF94A3B8))),
              const SizedBox(height: 24),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title *',
                  hintText: 'e.g. Audit database connection pool',
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be blank';
                  }
                  if (value.trim().length < 5) {
                    return 'Title must be at least 5 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTier,
                dropdownColor: const Color(0xFF1E293B),
                decoration: InputDecoration(
                  labelText: 'Priority Tier *',
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'Urgent', child: Text('Urgent (P1)')),
                  DropdownMenuItem(value: 'High', child: Text('High (P2)')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium (P3)')),
                  DropdownMenuItem(value: 'Low', child: Text('Low (P4)')),
                ],
                onChanged: (val) => setState(() => _selectedTier = val!),
              ),
              const SizedBox(height: 16),

              // Estimated Duration
              TextFormField(
                controller: _minutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Estimated Duration (Minutes) *',
                  hintText: 'e.g. 45',
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Duration is required';
                  }
                  final num = int.tryParse(value.trim());
                  if (num == null || num <= 0) {
                    return 'Enter a positive integer';
                  }
                  if (num > 480) {
                    return 'Maximum single task duration is 480 mins (8 hours)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Validate & Submit Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

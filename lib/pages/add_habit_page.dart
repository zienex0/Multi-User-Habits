import 'package:flutter/material.dart';

class AddHabitPage extends StatefulWidget {
  // AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _habitDescriptionController =
      TextEditingController();
  final TextEditingController _habitGoalController = TextEditingController();
  final TextEditingController _habitMeasurementController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            // key: ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // habit name input field
                TextFormField(
                  controller: _habitNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Habit name...",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // habit description input field
                TextFormField(
                  controller: _habitDescriptionController,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Habit description",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // habit goal input field
                const Text(
                  'Daily Goal',
                  style: TextStyle(fontSize: 20),
                ),
                TextFormField(
                  controller: _habitGoalController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "1.5, 60, 500, ...",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                const Text(
                  'Measurement',
                  style: TextStyle(fontSize: 20),
                ),
                TextFormField(
                  controller: _habitMeasurementController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "km, m, h, min, pages, lines of code, ...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

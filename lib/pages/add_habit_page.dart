import 'package:flutter/material.dart';
// import 'package:multiuser_habits/components/habit_tile.dart';
import 'package:multiuser_habits/models/habit_model.dart';
import 'package:multiuser_habits/services/habits_provider.dart';
import 'package:multiuser_habits/services/db_habits_service.dart';
import 'package:provider/provider.dart';

class AddHabitPage extends StatefulWidget {
  // AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _habitDescriptionController =
      TextEditingController();
  final TextEditingController _habitGoalController = TextEditingController();
  final TextEditingController _habitMeasurementController =
      TextEditingController();

  bool _othersCanParticipate = true;
  double _habitGoal = 0;

  @override
  void dispose() {
    _habitNameController.dispose();
    _habitDescriptionController.dispose();
    _habitGoalController.dispose();
    _habitMeasurementController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        Habit newHabit = Habit(
          name: _habitNameController.text,
          description: _habitDescriptionController.text,
          creatorId: "your_creator_id",
          goal: _habitGoal,
          measurement: _habitMeasurementController.text,
          isActive: true,
          isPrivate: !_othersCanParticipate,
          creationDate: DateTime.now(),
        );

        await DbHabits().addHabit(newHabit);

        if (mounted) {
          context.read<HabitsProvider>().fetchAllHabits();
          Navigator.pop(context);
          print("Form submitted successfully and habit created");
        }
      } catch (e) {
        print("Failed to create a habit: $e");
      }
    } else {
      print("Form validation failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
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
                        onChanged: (value) {
                          setState(() {
                            _habitNameController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a habit name";
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a habit description";
                          }
                          return null;
                        },
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          hintText: "1.5, 60, 500, ...",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            num? parsedGoal =
                                num.tryParse(value.replaceAll(',', '.'));
                            if (parsedGoal != null) {
                              _habitGoal = parsedGoal.toDouble();
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a daily goal";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // measurement input field
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
                        onChanged: (value) {
                          setState(() {
                            _habitMeasurementController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a measurement";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // is habit available for other users
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Other users can \nparticipate in this habit',
                            style: TextStyle(fontSize: 20),
                          ),
                          Switch(
                              value: _othersCanParticipate,
                              onChanged: (bool newValue) {
                                setState(() {
                                  _othersCanParticipate = newValue;
                                });
                              })
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                // HABIT PREVIEW
                // const Text("Preview"),
                // HabitTile(
                //     habitName: _habitNameController.text,
                //     habitDescription: _habitDescriptionController.text,
                //     habitGoal: _habitGoal,
                //     habitMeasurement: _habitMeasurementController.text,
                //     isPrivate: _othersCanParticipate),

                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Create Habit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

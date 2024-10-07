import 'package:flutter/material.dart';
import 'package:multiuser_habits/components/habit_tile.dart';
import 'package:multiuser_habits/models/habit_model.dart';
import 'package:multiuser_habits/services/form_validator.dart';
import 'package:multiuser_habits/services/habits_provider.dart';
import 'package:multiuser_habits/services/db_habits_service.dart';
import 'package:provider/provider.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final _formKey = GlobalKey<FormState>();

  final _habitNameController = TextEditingController();
  final _habitDescriptionController = TextEditingController();
  final _habitGoalController = TextEditingController();
  final _habitMeasurementController = TextEditingController();

  final _nameFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _goalFocus = FocusNode();
  final _measurementFocus = FocusNode();

  String _habitName = '';
  String _habitDescription = '';
  final String _creatorId = 'sample_creator_id';
  double _habitGoal = 0;
  String _measurement = '';
  final bool _isActive = true;
  bool _othersCanParticipate = true;
  final DateTime _creationDateTime = DateTime.now();

  bool _isLoading = false;

  Habit previewHabit = Habit(
    name: '',
    description: '',
    creatorId: '',
    goal: 0.0,
    measurement: 'none',
    isActive: false,
    isPrivate: false,
    creationDate: DateTime.now(),
  );

  @override
  void dispose() {
    _habitNameController.dispose();
    _habitDescriptionController.dispose();
    _habitGoalController.dispose();
    _habitMeasurementController.dispose();
    super.dispose();
  }

  void _updatePreviewHabit() {
    setState(() {
      previewHabit = Habit(
          name: _habitName,
          description: _habitDescription,
          creatorId: _creatorId,
          goal: _habitGoal,
          measurement: _measurement,
          isActive: _isActive,
          isPrivate: _othersCanParticipate,
          creationDate: _creationDateTime);
    });
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        Habit newHabit = Habit(
          name: _habitName,
          description: _habitDescription,
          creatorId: "your_creator_id",
          goal: _habitGoal,
          measurement: _measurement,
          isActive: _isActive,
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
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Form validation failed.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.blue,
      body: GestureDetector(
        onTap: () {
          _nameFocus.unfocus();
          _descriptionFocus.unfocus();
          _measurementFocus.unfocus();
          _goalFocus.unfocus();
        },
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
                          focusNode: _nameFocus,
                          decoration: const InputDecoration(
                            hintText: "Habit name...",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _habitName = value.trim();
                              _updatePreviewHabit();
                            });
                          },
                          validator: (value) => FormValidator.validateRequired(
                              'Habit name', value!)),

                      const SizedBox(
                        height: 20,
                      ),

                      // habit description input field
                      TextFormField(
                        controller: _habitDescriptionController,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocus,
                        decoration: const InputDecoration(
                          hintText: "Habit description",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _habitDescription = value.trim();
                          _updatePreviewHabit();
                        },
                        validator: (value) => FormValidator.validateRequired(
                            "Habit description", value!),
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
                        focusNode: _goalFocus,
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
                              _updatePreviewHabit();
                            }
                          });
                        },
                        validator: (value) => FormValidator.validateRequired(
                            'Daily goal', value!),
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
                        focusNode: _measurementFocus,
                        decoration: const InputDecoration(
                          hintText: "km, m, h, min, pages, lines of code, ...",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _measurement = value.trim();
                            _updatePreviewHabit();
                          });
                        },
                        validator: (value) => FormValidator.validateRequired(
                            'Measurement', value!),
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
                                  _updatePreviewHabit();
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
                const Text("Preview"),
                HabitTile(habit: previewHabit),

                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Create Habit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

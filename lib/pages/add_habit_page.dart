import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiuser_habits/components/habit_tile.dart';
import 'package:multiuser_habits/models/habit_model.dart';
import 'package:multiuser_habits/services/form_validator.dart';
import 'package:multiuser_habits/services/habits_provider.dart';
import 'package:multiuser_habits/services/db_habits_service.dart';
import 'package:multiuser_habits/utilities.dart';
import 'package:provider/provider.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final _currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();

  final _habitTitleController = TextEditingController();
  final _habitDescriptionController = TextEditingController();
  final _habitDailyGoalController = TextEditingController();
  final _habitMeasurementController = TextEditingController();

  final _nameFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _goalFocus = FocusNode();
  final _measurementFocus = FocusNode();

  String _habitTitle = '';
  String _habitDescription = '';
  double _habitDailyGoal = 0;
  String _measurement = '';
  final DateTime _creationDateTime = DateTime.now();

  bool _isLoading = false;

  Habit previewHabit = Habit(
      id: 'PREVIEW_HABIT_ID',
      title: '',
      description: '',
      creatorUid: FirebaseAuth.instance.currentUser!.uid,
      joinCode: 'PREVIEW_JOIN_CODE',
      dailyGoal: 0.0,
      measurement: 'none',
      creationDate: DateTime.now(),
      userUids: [FirebaseAuth.instance.currentUser!.uid]);

  @override
  void dispose() {
    _habitTitleController.dispose();
    _habitDescriptionController.dispose();
    _habitDailyGoalController.dispose();
    _habitMeasurementController.dispose();
    super.dispose();
  }

  void _updatePreviewHabit() {
    setState(() {
      previewHabit = Habit(
          id: 'PREVIEW_HABIT_ID',
          title: _habitTitle,
          description: _habitDescription,
          creatorUid: _currentUserUid,
          dailyGoal: _habitDailyGoal,
          joinCode: 'PREVIEW_JOIN_CODE',
          measurement: _measurement,
          creationDate: _creationDateTime,
          userUids: [_currentUserUid]);
    });
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        final Habit? habit = await DbHabits().addHabit(
            title: _habitTitle,
            description: _habitDescription,
            creatorUid: _currentUserUid,
            creationDate: Timestamp.now(),
            measurement: _measurement,
            dailyGoal: _habitDailyGoal,
            joinCode: 'CHANGE THIS CODE LATER',
            userUids: [_currentUserUid]);

        if (habit == null) {
          throw "Failed to create a habit when submiting";
        }

        print("Habit successfuly created with id ${habit.id}");

        if (mounted) {
          context
              .read<HabitsProvider>()
              .fetchHabitsConnectedToUser(userUid: _currentUserUid);
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
                          controller: _habitTitleController,
                          keyboardType: TextInputType.text,
                          focusNode: _nameFocus,
                          decoration: const InputDecoration(
                            hintText: "Running",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _habitTitle = value.trim();
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
                          hintText:
                              "Let's run everyday to build up our habit score to the max!",
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
                        controller: _habitDailyGoalController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          filteringTextInputOnlyNumbersWithDecimalPoint
                        ],
                        focusNode: _goalFocus,
                        decoration: const InputDecoration(
                          hintText: "99 999, 6.5, 10, ...",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            num? parsedGoal =
                                num.tryParse(value.replaceAll(',', '.'));
                            if (parsedGoal != null) {
                              _habitDailyGoal = parsedGoal.toDouble();
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
                    ],
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                // HABIT PREVIEW
                const Text("Preview"),
                HabitTile(
                  habit: previewHabit,
                  preview: true,
                ),

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

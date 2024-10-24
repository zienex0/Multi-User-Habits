import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiuser_habits/models/habit_check_model.dart';
import 'package:multiuser_habits/services/db_habit_checks_service.dart';
import 'package:multiuser_habits/utilities.dart';

DbHabitChecks _dbHabitChecks = DbHabitChecks();
final _auth = FirebaseAuth.instance;

Future<HabitCheck?> showCompleteHabitDialog({
  required BuildContext context,
  required String habitMeasurement,
  required String habitId,
}) async {
  final textMeasurementController = TextEditingController();
  final textUserNoteController = TextEditingController();
  String completionQuantityInput = '';
  bool isLoading = false;

  double? completionQuantity;
  return showDialog<HabitCheck?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Complete this habit",
            style: TextStyle(fontSize: 20),
          ),
          // ALERT DIALOG CONTENT
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AMOUNT FIELD
                Row(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: TextField(
                        style: const TextStyle(fontSize: 24),
                        autofocus: true,
                        controller: textMeasurementController,
                        decoration: const InputDecoration(
                          hintText: "Amount",
                          hintStyle: TextStyle(fontSize: 20),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(),
                        inputFormatters: [
                          filteringTextInputOnlyNumbersWithDecimalPoint
                        ],
                        onChanged: (value) {
                          completionQuantityInput = value.trim();
                          completionQuantity = double.tryParse(
                              completionQuantityInput.replaceAll(r',', '.'));
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        habitMeasurement,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // USER NOTE FIELD
                TextField(
                  autofocus: true,
                  controller: textUserNoteController,
                  decoration: const InputDecoration(
                    hintText: "Guys, it's your turn now 🔥",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                )
              ],
            ),
          ),
          actions: [
            // CANCEL BUTTON
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            // SUBMIT BUTTON
            TextButton(
              onPressed: () async {
                if (completionQuantity != null &&
                    _auth.currentUser != null &&
                    !isLoading) {
                  isLoading = true;
                  HabitCheck? habitCheck = await DbHabitChecks.addHabitCheck(
                      habitId: habitId,
                      quantity: completionQuantity!,
                      userNote: textUserNoteController.text.trim(),
                      userUid: _auth.currentUser!.uid);
                  completionQuantity = null;
                  isLoading = false;
                  if (context.mounted) {
                    Navigator.pop(context, habitCheck);
                  }
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      });
}

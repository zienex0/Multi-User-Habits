import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiuser_habits/services/db_habit_checks_service.dart';
import 'package:multiuser_habits/constants.dart';

class HabitCheckSumRectangle extends StatelessWidget {
  HabitCheckSumRectangle(
      {required this.habitId,
      required this.habitMeasurement,
      required this.colorId,
      required this.preview,
      super.key});

  final DbHabitChecks dbHabitChecks = DbHabitChecks();
  final String habitId;
  final String habitMeasurement;
  final String colorId;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    if (preview) {
      return _buildStaticRectangle("0", habitMeasurement, colorId);
    }

    return StreamBuilder(
        stream: dbHabitChecks.getHabitChecksCompletionSum(habitId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(
                'Something went wrong while future building the habit checks completion sum');
            return const Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildStaticRectangle("...", "loading...", colorId);
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return _buildStaticRectangle("0", habitMeasurement, colorId);
          }

          if (snapshot.data!.roundToDouble() == snapshot.data) {
            return _buildStaticRectangle(
                snapshot.data!.toStringAsFixed(0), habitMeasurement, colorId);
          }

          return _buildStaticRectangle(
              snapshot.data!.toStringAsFixed(1), habitMeasurement, colorId);
        });
  }

  Widget _buildStaticRectangle(
      String score, String measurement, String colorId) {
    return Container(
      // height: 100,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(46, 46, 46, 1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // HABIT SCORE
          Text(
            score,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: kHabitTileColorMap[colorId]),
            ),
          ),
          // HABIT SCORE MEASUREMENT
          Text(
            measurement.trim().isEmpty ? "Completions" : measurement.trim(),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              textStyle:
                  TextStyle(fontSize: 16, color: kHabitTileColorMap[colorId]),
            ),
          )
        ],
      ),
    );
  }
}

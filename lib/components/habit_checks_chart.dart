import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiuser_habits/constants.dart';
import 'package:multiuser_habits/models/habit_check_model.dart';
import 'package:multiuser_habits/models/habit_model.dart';
import 'package:multiuser_habits/services/db_habit_checks_service.dart';

class HabitChecksChart extends StatelessWidget {
  const HabitChecksChart({required this.habit, super.key});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final mainColor = kHabitTileColorMap[habit.colorId]!;

    return AspectRatio(
      aspectRatio: 2.0,
      child: StreamBuilder<List<HabitCheck>>(
          stream: DbHabitChecks.getHabitChecksStream(habit.id,
              userUid: FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Text("Something went wrong");
            }

            List<HabitCheck> habitChecks = snapshot.data!;
            List<FlSpot> chartSpots = _aggregateHabitChecksByDay(habitChecks);

            double minX = chartSpots.isEmpty ? 0 : chartSpots.first.x;
            double maxX = chartSpots.isEmpty ? 0 : chartSpots.last.x;

            return Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: LineChart(
                LineChartData(
                  minY: 0,
                  minX: minX,
                  maxX: maxX,
                  borderData: FlBorderData(
                    show: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (value, meta) {
                          return Center(
                            child: Text(
                              NumberFormat.compact().format(value),
                              style: TextStyle(
                                color: Colors.grey.shade800,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.fromMillisecondsSinceEpoch(
                              value.toInt());
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Transform.rotate(
                              angle: -0.5,
                              child: Text(
                                DateFormat('dd/MM').format(date),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          );
                        },
                        reservedSize: 30, // Increase space for rotated text
                        interval: 86400000.0 *
                            2, // Show date every day (86400000 is milliseconds in a day)
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: false,
                  ),
                  // HERE IS THE DATA
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartSpots,
                      color: mainColor.withOpacity(0.8),
                      shadow: const Shadow(blurRadius: 6, color: Colors.black),
                      isCurved: true,
                      barWidth: 3,
                      curveSmoothness: 0.35,
                      preventCurveOverShooting: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            mainColor.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                  // LineChartData(),
                ),
              ),
            );
          }),
    );
  }

  List<FlSpot> _aggregateHabitChecksByDay(List<HabitCheck> habitChecks) {
    final Map<String, double> dailySums = {};

    for (var check in habitChecks) {
      final date = DateTime(
        check.completionDate.year,
        check.completionDate.month,
        check.completionDate.day,
      );
      final dateKey = date.millisecondsSinceEpoch.toString();

      dailySums[dateKey] = (dailySums[dateKey] ?? 0) + check.quantity;
    }

    return dailySums.entries
        .map((entry) => FlSpot(
              double.parse(entry.key),
              entry.value,
            ))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiuser_habits/components/habit_check_sum_rectangle.dart';
import 'package:multiuser_habits/components/habit_users_avatars.dart';
import 'package:multiuser_habits/constants.dart';
import 'package:multiuser_habits/models/habit_check_model.dart';
import 'package:multiuser_habits/models/habit_model.dart';
import 'package:multiuser_habits/models/user_model.dart';
import 'package:multiuser_habits/services/db_habit_checks_service.dart';
import 'package:multiuser_habits/services/db_users_service.dart';
import 'package:timeago/timeago.dart' as timeago;

final _auth = FirebaseAuth.instance;

class HabitDetailsPage extends StatelessWidget {
  const HabitDetailsPage({required this.habit, super.key});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // * HABIT TITLE AND COMPLETION BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    habit.title,
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // * MY HABIT SUMMARY (MY SCORE AND CURRENT DAILY STREAK)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                ),
                child: CurrentUserHabitSummary(habit: habit),
              ),

              const SizedBox(
                height: 20,
              ),

              // * USERS CONTRIBUTING AND COMPLETION SUM
              UsersContributingAndAllScore(habit: habit),

              const SizedBox(
                height: 20,
              ),

              Divider(
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 90,
                    decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Latest",
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 90,
                    decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "My",
                          style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: Colors.white.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 90,
                    decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Top",
                          style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: Colors.white.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              // * LIST OF LATEST COMPLETIONS
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: LatestHabitCheckCompletionsStreamBuilder(habit: habit),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LatestHabitCheckCompletionsStreamBuilder extends StatelessWidget {
  const LatestHabitCheckCompletionsStreamBuilder({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbHabitChecks().getLatestHabitCheckCompletion(habit.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Text("Something went wrong");
          }
          if (ConnectionState.waiting == snapshot.connectionState) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Text("No completions yet hehe");
          }
          final latestCompletion = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: UserHabitCheckCompletionTile(
              habitCheck: latestCompletion,
              habit: habit,
            ),
          );
        });
  }
}

class UserHabitCheckCompletionTile extends StatelessWidget {
  const UserHabitCheckCompletionTile({
    super.key,
    required this.habitCheck,
    required this.habit,
  });

  final HabitCheck habitCheck;
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: Icon(Icons.person),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  HabitCheckUserUsernameExtractor(userUid: habitCheck.userUid),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    timeago.format(habitCheck.completionDate),
                    style: GoogleFonts.roboto(
                        fontSize: 16, color: Colors.white.withOpacity(0.4)),
                  ),
                ],
              ),
              Text(
                "${habitCheck.quantity} ${habit.measurement}",
                style: GoogleFonts.roboto(
                  color: kHabitTileColorMap[habit.colorId],
                  fontSize: 24,
                ),
              ),
              Text(
                habitCheck.userNote.isNotEmpty
                    ? habitCheck.userNote
                    : "No note left",
                style: GoogleFonts.roboto(fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class HabitCheckUserUsernameExtractor extends StatelessWidget {
  const HabitCheckUserUsernameExtractor({
    super.key,
    required this.userUid,
  });

  final String userUid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DbUsers().getUser(userUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
                height: 30, width: 100, child: LinearProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox(
                height: 30, width: 100, child: LinearProgressIndicator());
          }

          CustomUser? habitCheckUser = snapshot.data;
          if (habitCheckUser == null) {
            return const SizedBox(
                height: 30, width: 100, child: LinearProgressIndicator());
          }
          return Text(
            habitCheckUser.displayName,
            style: GoogleFonts.roboto(fontSize: 16),
          );
        });
  }
}

class UsersContributingAndAllScore extends StatelessWidget {
  const UsersContributingAndAllScore({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "X users",
                        // TODO MAKE THE X THE ACTUAL USER COUNT
                        style: TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(
                        Icons.format_list_bulleted_add,
                        size: 40,
                        color: Colors.white,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: HabitUsersAvatars(
                      habitId: habit.id,
                      preview: false,
                      includeMyAvatar: true,
                      maxUsersToShow: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: HabitCheckSumRectangle(
                    habitId: habit.id,
                    habitMeasurement: habit.measurement,
                    colorId: habit.colorId,
                    preview: false)
                .copyWithBackgroundColor(Colors.transparent),
          ),
        ),
      ],
    );
  }
}

class CurrentUserHabitSummary extends StatelessWidget {
  const CurrentUserHabitSummary({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
            Text(
              _auth.currentUser!.displayName != null
                  ? _auth.currentUser!.displayName!
                  : "Anynomous",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.all_inclusive),
                            Text(
                              'X',
                              style: GoogleFonts.roboto(fontSize: 24),
                            ),
                          ],
                        ),
                        Text(
                          "streak",
                          style: GoogleFonts.roboto(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // * MY HABIT SCORE SUM
                Expanded(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: kHabitTileColorMap[habit.colorId]!)),
                    child: HabitCheckSumRectangle(
                            habitId: habit.id,
                            userUid: _auth.currentUser!.uid,
                            habitMeasurement: habit.measurement,
                            colorId: habit.colorId,
                            preview: false)
                        .copyWithBackgroundColor(Colors.transparent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

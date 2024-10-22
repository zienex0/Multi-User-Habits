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
const int maxLatestCompletions = 3;
const double _bigIconSize = 50.0;
const double _smallIconSize = 20.0;

class HabitDetailsPage extends StatelessWidget {
  const HabitDetailsPage({required this.habit, super.key});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkPrimaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 70,
              right: 10,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    habit.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 40, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CurrentUserHabitSummary(habit: habit),
                  ),
                ],
              ),
            ),
            DraggableScrollableSheet(
                initialChildSize: 0.40,
                minChildSize: 0.4,
                maxChildSize: 0.8,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 80,
                          blurStyle: BlurStyle.solid,
                          color: Colors.black,
                          offset: Offset.zero,
                          spreadRadius: -10,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: _buildHabitCompletions(habit),
                    ),
                  );
                }),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: _smallIconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitCompletions(Habit habit) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: Colors.white.withOpacity(0.5)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                UsersContributingAndAllScore(habit: habit),
                const SizedBox(height: 20),
                Divider(
                  thickness: 3,
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTabButton("Latest", true),
                    _buildTabButton("My", false),
                    _buildTabButton("Top", false),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kDarkPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      LatestHabitCheckCompletionsStreamBuilder(
                        habit: habit,
                      ),
                      const Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 80,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kBackgroundColor, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String text, bool isActive) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color:
            isActive ? kDarkPrimaryColor : kDarkPrimaryColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 20,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
            ),
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
        stream: DbHabitChecks()
            .getLatestHabitCheckCompletions(habit.id, maxLatestCompletions),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Text("Something went wrong");
          }
          if (ConnectionState.waiting == snapshot.connectionState) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return const Column(
              children: [
                SizedBox(
                  height: _bigIconSize,
                ),
                Text("No completions yet hehe"),
              ],
            );
          }
          final latestCompletions = snapshot.data!;
          print(latestCompletions);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                for (int index = 0; index < latestCompletions.length; index++)
                  Column(
                    children: [
                      UserHabitCheckCompletionTile(
                        habitCheck: latestCompletions[index],
                        habit: habit,
                      ),
                      index < maxLatestCompletions
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5),
                              child: Divider(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
              ],
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
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.person),
          ),
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
                  // color: kHabitTileColorMap[habit.colorId],
                  color: Colors.white,
                  fontSize: 24,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        habitCheck.userNote.isEmpty
            ? Container()
            : const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.remove_red_eye_rounded,
                  size: 30,
                ),
              )
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
              color: kDarkPrimaryColor,
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
              color: kDarkPrimaryColor,
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
        color: Colors.transparent,
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

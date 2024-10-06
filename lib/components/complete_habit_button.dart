import 'package:flutter/material.dart';

class CompleteHabitButton extends StatefulWidget {
  const CompleteHabitButton({super.key});

  @override
  State<CompleteHabitButton> createState() => _CompleteHabitButtonState();
}

class _CompleteHabitButtonState extends State<CompleteHabitButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 255, 255, 255),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(7),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          splashColor: Colors.green.withOpacity(0.5),
          onTap: () {},
          child: const Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PreviewUsersAvatars extends StatelessWidget {
  const PreviewUsersAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    const previewUserCount = 5;
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          for (int i = 0; i < previewUserCount; i++)
            Positioned(
              left: i * 20,
              child: const CircleAvatar(
                radius: 20,
                child: Icon(Icons.person),
              ),
            )
        ],
      ),
    );
  }
}

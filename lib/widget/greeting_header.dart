import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  final String username;
  final String subtitle;
  final String avatarUrl;

  const GreetingHeader({
    super.key,
    required this.username,
    required this.subtitle,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, $username 👋",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const Spacer(),
        CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(avatarUrl),
        ),
      ],
    );
  }
}

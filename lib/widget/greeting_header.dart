import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  final String username;
  final String subtitle;
  final String avatarUrl;
  final VoidCallback onLogout;

  const GreetingHeader({
    super.key,
    required this.username,
    required this.subtitle,
    required this.avatarUrl,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ---- Left Side ----
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, $username 👋",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),

        // ---- Right Side ----
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 26, backgroundImage: NetworkImage(avatarUrl)),
            SizedBox(width: 8),

            IconButton(
              onPressed: onLogout,
              icon: Icon(Icons.logout, color: Colors.red),
              tooltip: "Logout",
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String imageUrl;
  final String status;
  final VoidCallback? onCallPressed;

  const ChatAppBar({
    super.key,
    required this.name,
    required this.imageUrl,
    this.status = 'en línea',
    this.onCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.teal,
      elevation: 2,
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                status,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: onCallPressed ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función de llamada próximamente 📞')),
                );
              },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
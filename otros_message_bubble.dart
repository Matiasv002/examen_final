import 'package:flutter/material.dart';
import 'package:examen_final/dominio/message.dart';
import 'package:intl/intl.dart';

class OtrosMessageBubble extends StatelessWidget {
  final Message message;
  final String avatarUrl;
  final Function(Message)? onReplyTap;

  const OtrosMessageBubble({
    super.key,
    required this.message,
    this.avatarUrl = 'https://i.pravatar.cc/150?img=47',
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 👤 Avatar
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.grey[300],
          ),

          const SizedBox(width: 8),

          // 💬 Burbuja
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(maxWidth: 280),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 💬 Reply Preview
                      if (message.replyTo != null) ...[
                        GestureDetector(
                          onTap: () => onReplyTap?.call(message.replyTo!),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              border: const Border(
                                left: BorderSide(color: Colors.teal, width: 3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.replyTo!.voce == Voce.kMe
                                      ? 'Tú'
                                      : 'María',
                                  style: const TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  message.replyTo!.text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      // 🖼️ GIF primero
                      if (message.gifUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            message.gifUrl!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 200,
                                height: 200,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.teal,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // 📝 Texto
                      Text(
                        message.text,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // 🕐 Hora
                      Text(
                        timeFormat.format(message.timestamp),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // 😊 Reacciones
                if (message.reactions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 8, top: 2),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: message.reactions.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

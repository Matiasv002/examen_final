import 'package:flutter/material.dart';
import 'package:examen_final/dominio/message.dart';
import 'package:intl/intl.dart';

class MyMessageBubble extends StatelessWidget {
  final Message message;
  final Function(Message)? onReplyTap;

  const MyMessageBubble({
    super.key,
    required this.message,
    this.onReplyTap,
  });

  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return const Icon(Icons.access_time, size: 14, color: Colors.white70);
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 16, color: Colors.white70);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 16, color: Colors.white70);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 16, color: Colors.lightBlueAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: const Color(0xFF005C4B),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 💬 Reply Preview
                if (message.replyTo != null) ...[
                  GestureDetector(
                    onTap: () => onReplyTap?.call(message.replyTo!),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: const Border(
                          left: BorderSide(color: Colors.white, width: 3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.replyTo!.voce == Voce.kMe ? 'Tú' : 'María',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            message.replyTo!.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // 📝 Texto del mensaje
                Text(
                  message.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                // 🖼️ GIF si existe
                if (message.gifUrl != null) ...[
                  const SizedBox(height: 8),
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
                          color: Colors.white24,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 4),

                // 🕐 Hora + Ticks
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeFormat.format(message.timestamp),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 4),
                    _buildStatusIcon(),
                  ],
                ),
              ],
            ),
          ),

          // 😊 Reacciones
          if (message.reactions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 8, top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }
}

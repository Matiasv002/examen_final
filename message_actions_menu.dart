import 'package:flutter/material.dart';

/// Menú contextual para acciones de mensaje (reacciones, responder, etc.)
class MessageActionsMenu {
  static Future<String?> show({
    required BuildContext context,
    required Offset position,
    required bool isMyMessage,
  }) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    return await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        // Reacciones rápidas
        const PopupMenuItem<String>(
          value: 'reactions',
          height: 60,
          child: ReactionBar(),
        ),
        const PopupMenuDivider(),
        // Responder
        PopupMenuItem<String>(
          value: 'reply',
          child: Row(
            children: [
              Icon(Icons.reply, color: Colors.grey[700], size: 20),
              const SizedBox(width: 12),
              const Text('Responder'),
            ],
          ),
        ),
        // Copiar (solo si es texto)
        if (!isMyMessage)
          PopupMenuItem<String>(
            value: 'copy',
            child: Row(
              children: [
                Icon(Icons.copy, color: Colors.grey[700], size: 20),
                const SizedBox(width: 12),
                const Text('Copiar'),
              ],
            ),
          ),
        // Eliminar (solo mensajes propios)
        if (isMyMessage)
          const PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.red, size: 20),
                SizedBox(width: 12),
                Text('Eliminar', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
      ],
    );
  }

  /// Muestra solo el selector de reacciones
  static Future<String?> showReactions({
    required BuildContext context,
    required Offset position,
  }) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    return await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      items: const [
        PopupMenuItem<String>(
          value: 'reactions',
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: ReactionBar(),
        ),
      ],
    );
  }
}

/// Barra de reacciones rápidas
class ReactionBar extends StatelessWidget {
  const ReactionBar({super.key});

  static const List<String> emojis = ['❤️', '👍', '😂', '😮', '😢', '🙏'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: emojis.map((emoji) {
        return InkWell(
          onTap: () => Navigator.pop(context, emoji),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      }).toList(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:examen_final/dominio/message.dart';
import 'package:examen_final/presentacion/provider/chat_provider.dart';
import 'package:examen_final/presentacion/widgets/chat/my_message_bubble.dart';
import 'package:examen_final/presentacion/widgets/chat/otros_message_bubble.dart';
import 'package:examen_final/presentacion/widgets/chat/typing_indicator.dart';
import 'package:examen_final/presentacion/widgets/shared/message_field_box.dart';
import 'package:examen_final/presentacion/widgets/chat/message_actions_menu.dart';
import 'package:examen_final/presentacion/widgets/chat/editable_chat_header.dart';

/// Pantalla principal del chat con reacciones y respuestas
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  Offset? _tapPosition;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Guarda la posición del tap para el menú contextual
  void _storeTapPosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  /// Muestra el menú de acciones del mensaje
  void _showMessageActions(BuildContext context, Message message) async {
    if (_tapPosition == null) return;

    final chatProvider = context.read<ChatProvider>();

    final action = await MessageActionsMenu.show(
      context: context,
      position: _tapPosition!,
      isMyMessage: message.voce == Voce.kMe,
    );

    if (action == null) return;

    switch (action) {
      case 'reply':
        chatProvider.setReplyingTo(message);
        break;
      case 'copy':
        Clipboard.setData(ClipboardData(text: message.text));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mensaje copiado'),
              duration: Duration(seconds: 1),
            ),
          );
        }
        break;
      case 'delete':
        chatProvider.deleteMessage(message);
        break;
      default:
        // Es una reacción (emoji)
        if (action.isNotEmpty) {
          chatProvider.addReaction(message, action);
        }
    }
  }

  /// Scroll a un mensaje citado
  void _scrollToReplyMessage(Message replyMessage) {
    final chatProvider = context.read<ChatProvider>();
    final index = chatProvider.findMessageIndex(replyMessage.id);

    if (index != null) {
      chatProvider.scrollToMessage(index);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      // 🔥 NUEVO: Header editable con nombre y avatar
      appBar: const EditableChatHeader(),
      
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/chat_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Banner informativo
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.teal.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.teal.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Termina tu mensaje con "!" para recibir respuesta',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.teal.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de mensajes
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatProvider.messages.length +
                      (chatProvider.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Mostrar typing indicator
                    if (chatProvider.isTyping &&
                        index == chatProvider.messages.length) {
                      return TypingIndicator(
                        avatarUrl: chatProvider.contactAvatar,
                      );
                    }

                    final message = chatProvider.messages[index];

                    // Envolver en GestureDetector para capturar la posición
                    return GestureDetector(
                      onTapDown: _storeTapPosition,
                      onLongPress: () => _showMessageActions(context, message),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          final offsetAnimation = Tween<Offset>(
                            begin: message.voce == Voce.kMe
                                ? const Offset(0.2, 0)
                                : const Offset(-0.2, 0),
                            end: Offset.zero,
                          ).animate(animation);

                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            ),
                          );
                        },
                        child: message.voce == Voce.kMe
                            ? MyMessageBubble(
                                key: ValueKey(message.id),
                                message: message,
                                onReplyTap: _scrollToReplyMessage,
                              )
                            : OtrosMessageBubble(
                                key: ValueKey(message.id),
                                message: message,
                                avatarUrl: chatProvider.contactAvatar,
                                onReplyTap: _scrollToReplyMessage,
                              ),
                      ),
                    );
                  },
                ),
              ),

              // Preview del mensaje al que se está respondiendo
              if (chatProvider.replyingTo != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chatProvider.replyingTo!.voce == Voce.kMe
                                  ? 'Respondiendo a ti'
                                  : 'Respondiendo a ${chatProvider.contactName}',
                              style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              chatProvider.replyingTo!.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => chatProvider.setReplyingTo(null),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

              // Campo de texto
              MessageFieldBox(
                controller: _textController,
                onSend: (value) => chatProvider.sendMessage(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
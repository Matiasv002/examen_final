import 'package:flutter/material.dart';

/// Widget reutilizable mejorado para el campo de texto del chat.
/// 
/// Características:
/// - ✅ Expansión automática multilínea (hasta 5 líneas)
/// - ✅ Botón de envío reactivo con animación
/// - ✅ Contador de caracteres opcional
/// - ✅ Botones para adjuntar archivos y emojis
/// - ✅ Animaciones suaves y feedback visual
/// - ✅ Performance optimizado con ValueNotifier
/// - ✅ Estilo WhatsApp moderno
class MessageFieldBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final VoidCallback? onAttachFile;
  final VoidCallback? onEmojiPressed;
  final int maxLines;
  final int? maxLength;
  final bool showCharCounter;
  final String hintText;

  const MessageFieldBox({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttachFile,
    this.onEmojiPressed,
    this.maxLines = 5,
    this.maxLength,
    this.showCharCounter = false,
    this.hintText = "Escribe un mensaje",
  });

  @override
  State<MessageFieldBox> createState() => _MessageFieldBoxState();
}

class _MessageFieldBoxState extends State<MessageFieldBox> 
    with SingleTickerProviderStateMixin {
  
  late final ValueNotifier<bool> _hasText;
  late final AnimationController _sendButtonController;
  late final Animation<double> _sendButtonScale;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _hasText = ValueNotifier(widget.controller.text.trim().isNotEmpty);
    
    // Animación para el botón de enviar
    _sendButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _sendButtonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sendButtonController, curve: Curves.easeOut),
    );

    // Escuchar cambios en el texto
    widget.controller.addListener(_onTextChanged);
    
    if (_hasText.value) {
      _sendButtonController.forward();
    }
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (_hasText.value != hasText) {
      _hasText.value = hasText;
      if (hasText) {
        _sendButtonController.forward();
      } else {
        _sendButtonController.reverse();
      }
    }
  }

  void _handleSend() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      widget.controller.clear();
      _focusNode.requestFocus(); // Mantener el foco después de enviar
    }
  }

  @override
  void dispose() {
    _hasText.dispose();
    _sendButtonController.dispose();
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor == Colors.blue 
        ? Colors.teal // Usar teal para mantener consistencia con tu AppBar
        : theme.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Botón de adjuntar (opcional)
              if (widget.onAttachFile != null) ...[
                _AttachButton(
                  onPressed: widget.onAttachFile!,
                  color: Colors.grey[600]!,
                ),
                const SizedBox(width: 4),
              ],

              // Campo de texto expandible
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: widget.maxLines * 24.0 + 20, // altura dinámica
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Botón de emoji (opcional)
                      if (widget.onEmojiPressed != null)
                        IconButton(
                          icon: Icon(Icons.emoji_emotions_outlined, 
                                   color: Colors.grey[600]),
                          onPressed: widget.onEmojiPressed,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),

                      // TextField
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          maxLines: null, // permite múltiples líneas
                          minLines: 1,
                          maxLength: widget.maxLength,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            counterText: widget.showCharCounter ? null : '',
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 16),
                          // Enviar con Ctrl+Enter o Cmd+Enter
                          onSubmitted: (_) => _handleSend(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Botón de enviar animado
              ValueListenableBuilder<bool>(
                valueListenable: _hasText,
                builder: (context, hasText, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    child: hasText
                        ? ScaleTransition(
                            scale: _sendButtonScale,
                            child: Material(
                              color: primaryColor,
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: _handleSend,
                                child: const Center(
                                  child: Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Material(
                            color: Colors.grey[300],
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: widget.onAttachFile ?? () {},
                              child: Center(
                                child: Icon(
                                  Icons.mic_rounded,
                                  color: Colors.grey[600],
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón de adjuntar archivos
class _AttachButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;

  const _AttachButton({
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.attach_file_rounded, color: color, size: 22),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
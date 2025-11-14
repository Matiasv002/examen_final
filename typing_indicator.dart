import 'package:flutter/material.dart';

/// Widget que muestra el indicador de "escribiendo..."
/// Usado cuando la otra persona está escribiendo un mensaje
class TypingIndicator extends StatefulWidget {
  final String avatarUrl;
  
  const TypingIndicator({
    super.key,
    this.avatarUrl = 'https://i.pravatar.cc/150?img=47',
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 👤 Avatar
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(widget.avatarUrl),
            backgroundColor: Colors.grey[300],
          ),
          
          const SizedBox(width: 8),
          
          // 💬 Indicador de escritura animado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    // Crear efecto de onda en los 3 puntos
                    final delay = index * 0.2;
                    final value = (_controller.value - delay) % 1.0;
                    final opacity = (value < 0.5) 
                        ? value * 2 
                        : 2 - (value * 2);
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Opacity(
                        opacity: opacity.clamp(0.3, 1.0),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
enum Voce { kMe, kHer }

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
}

class Message {
  Message({
    required this.text,
    required this.voce,
    this.imageUrl,
    this.gifUrl,
    DateTime? timestamp,
    this.status = MessageStatus.sent,
    this.id,
    this.replyTo,
    this.reactions = const {},
  }) : timestamp = timestamp ?? DateTime.now();

  final String? id;
  final String text;
  final Voce voce;
  final String? imageUrl;
  final String? gifUrl;
  final DateTime timestamp;
  final MessageStatus status;
  final Message? replyTo; // 👈 NUEVO: Mensaje al que responde
  final Map<String, String> reactions; // 👈 NUEVO: emoji -> quien reaccionó

  Message copyWith({
    String? id,
    String? text,
    Voce? voce,
    String? imageUrl,
    String? gifUrl,
    DateTime? timestamp,
    MessageStatus? status,
    Message? replyTo,
    Map<String, String>? reactions,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      voce: voce ?? this.voce,
      imageUrl: imageUrl ?? this.imageUrl,
      gifUrl: gifUrl ?? this.gifUrl,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      replyTo: replyTo ?? this.replyTo,
      reactions: reactions ?? this.reactions,
    );
  }

  // Helper para generar IDs únicos
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

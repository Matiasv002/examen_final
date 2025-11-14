import 'package:flutter/material.dart';
import 'package:examen_final/dominio/message.dart';
import 'package:examen_final/infraestructura/get_yes_no_model.dart';

class ChatProvider extends ChangeNotifier {
  final List<Message> _messages = [];
  final ScrollController scrollController = ScrollController();
  bool _isTyping = false;
  Message? _replyingTo;
  
  // 👤 NUEVO: Nombre del contacto editable
  String _contactName = 'María López';
  String _contactAvatar = 'https://i.pravatar.cc/150?img=47';

  List<Message> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  Message? get replyingTo => _replyingTo;
  String get contactName => _contactName;
  String get contactAvatar => _contactAvatar;

  /// 👤 NUEVO: Actualizar nombre del contacto
  void updateContactName(String newName) {
    if (newName.trim().isNotEmpty) {
      _contactName = newName.trim();
      notifyListeners();
    }
  }

  /// 👤 NUEVO: Actualizar avatar del contacto
  void updateContactAvatar(String newAvatarUrl) {
    _contactAvatar = newAvatarUrl;
    notifyListeners();
  }

  /// Envía un mensaje del usuario (kMe)
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMessage = Message(
      id: Message.generateId(),
      text: text,
      voce: Voce.kMe,
      status: MessageStatus.sent,
      replyTo: _replyingTo,
    );

    _messages.add(newMessage);
    _replyingTo = null;
    notifyListeners();
    scrollToBottom();

    // Simular que el mensaje fue entregado
    Future.delayed(const Duration(milliseconds: 500), () {
      _updateMessageStatus(newMessage, MessageStatus.delivered);
    });

    // 🔥 CAMBIO: Solo responde si termina en "!" (ya no con "?")
    if (text.trim().endsWith('!')) {
      _simulateHerResponse();
    }
  }

  /// Establece el mensaje al que se está respondiendo
  void setReplyingTo(Message? message) {
    _replyingTo = message;
    notifyListeners();
  }

  /// Agrega una reacción a un mensaje
  void addReaction(Message message, String emoji) {
    final index = _messages.indexWhere((m) => m.id == message.id);
    if (index == -1) return;

    final updatedReactions = Map<String, String>.from(message.reactions);
    
    if (updatedReactions.containsKey(emoji)) {
      updatedReactions.remove(emoji);
    } else {
      updatedReactions.clear();
      updatedReactions[emoji] = message.voce == Voce.kMe ? 'me' : 'her';
    }

    _messages[index] = message.copyWith(reactions: updatedReactions);
    notifyListeners();
  }

  /// Elimina un mensaje
  void deleteMessage(Message message) {
    _messages.removeWhere((m) => m.id == message.id);
    notifyListeners();
  }

  /// Encuentra un mensaje por ID
  int? findMessageIndex(String? messageId) {
    if (messageId == null) return null;
    return _messages.indexWhere((m) => m.id == messageId);
  }

  /// Actualiza el estado de un mensaje
  void _updateMessageStatus(Message message, MessageStatus newStatus) {
    final index = _messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      _messages[index] = message.copyWith(status: newStatus);
      notifyListeners();
    }
  }

  /// Simula la respuesta automática de kHer
  Future<void> _simulateHerResponse() async {
    _isTyping = true;
    notifyListeners();
    scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 1500));

    final herMessage = await GetYesNoModel.getAnswer();
    
    final messageWithId = Message(
      id: Message.generateId(),
      text: herMessage.text,
      voce: herMessage.voce,
      gifUrl: herMessage.gifUrl,
      replyTo: _replyingTo,
    );

    _isTyping = false;
    _messages.add(messageWithId);
    notifyListeners();
    scrollToBottom();

    //
    // Marcar mensajes como leídos
    for (var i = 0; i < _messages.length; i++) {
      if (_messages[i].voce == Voce.kMe &&
          _messages[i].status != MessageStatus.read) {
        _messages[i] = _messages[i].copyWith(status: MessageStatus.read);
      }
    }
    notifyListeners();
  }

  /// Desplaza el scroll al final del chat
  Future<void> scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Scroll a un mensaje específico
  void scrollToMessage(int index) {
    if (!scrollController.hasClients) return;

    final position = index * 100.0;

    scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
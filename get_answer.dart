import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:examen_final/dominio/message.dart';

class GetAnswer {
  static Future<Message> generate() async {
    final url = Uri.parse('https://yesno.wtf/api');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Message(
        text: data['answer'],   // "yes", "no" o "maybe"
        gifUrl: data['image'],  // URL del gif
        voce: Voce.kHer,
      );
    } else {
      return Message(
        text: 'Error al obtener respuesta',
        voce: Voce.kHer,
      );
    }
  }
}
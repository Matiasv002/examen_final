import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:examen_final/dominio/message.dart';

class GetYesNoModel {
  static Future<Message> getAnswer() async {
    try {
      final url = Uri.parse('https://yesno.wtf/api');
      
      // Timeout para evitar esperas infinitas
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Timeout - La API no respondió a tiempo');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return Message(
          id: Message.generateId(),
          text: data['answer'], // "yes", "no" o "maybe"
          gifUrl: data['image'], // URL del gif
          voce: Voce.kHer,
        );
      } else {
        // Error del servidor
        return Message(
          id: Message.generateId(),
          text: 'Error: El servidor respondió con código ${response.statusCode}',
          voce: Voce.kHer,
        );
      }
    } on SocketException catch (e) {
      // Error de conexión de red
      print('❌ Error de conexión: $e');
      return Message(
        id: Message.generateId(),
        text: '❌ Sin conexión a internet. Verifica tu red.',
        voce: Voce.kHer,
      );
    } on HttpException catch (e) {
      // Error HTTP
      print('❌ Error HTTP: $e');
      return Message(
        id: Message.generateId(),
        text: '❌ Error al conectar con el servidor.',
        voce: Voce.kHer,
      );
    } on FormatException catch (e) {
      // Error al parsear JSON
      print('❌ Error de formato: $e');
      return Message(
        id: Message.generateId(),
        text: '❌ Respuesta del servidor inválida.',
        voce: Voce.kHer,
      );
    } catch (e) {
      // Cualquier otro error
      print('❌ Error desconocido: $e');
      return Message(
        id: Message.generateId(),
        text: '❌ Ocurrió un error inesperado: $e',
        voce: Voce.kHer,
      );
    }
  }
}
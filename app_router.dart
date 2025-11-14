import 'package:get/get.dart';
import 'package:examen_final/presentacion/screens/home_screen.dart';
import 'package:examen_final/presentacion/chat/chat_screen.dart';
import 'package:examen_final/presentacion/calculator/pantalla_calculadora.dart';

class AppRouter {
  static const String home = '/';
  static const String chat = '/chat';
  static const String calculadora = '/calculadora';

  static List<GetPage> get pages {
    return [
      GetPage(
        name: home,
        page: () => const HomeScreen(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: chat,
        page: () => const ChatScreen(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: calculadora,
        page: () => PantallaCalculadora(),
        transition: Transition.rightToLeft,
      ),
    ];
  }
}

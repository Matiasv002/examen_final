import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:examen_final/config/router/app_router.dart';
import 'package:examen_final/config/theme/app_theme.dart';
import 'package:examen_final/presentacion/provider/chat_provider.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: GetMaterialApp(
        title: 'Examen Final - Chat & Calculadora',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRouter.home,
        getPages: AppRouter.pages,
      ),
    );
  }
}

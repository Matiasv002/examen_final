import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:examen_final/config/router/app_router.dart';
import 'package:examen_final/presentacion/widgets/shared/app_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade400,
              Colors.teal.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Icon(
                      Icons.apps_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Examen Final',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecciona una aplicación',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Grid de Apps
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        // 💬 Chat App
                        AppCard(
                          title: 'Chat',
                          subtitle: 'Mensajería con IA',
                          icon: Icons.chat_bubble_rounded,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF128C7E), Color(0xFF075E54)],
                          ),
                          onTap: () => Get.toNamed(AppRouter.chat),
                        ),

                        // 🧮 Calculadora
                        AppCard(
                          title: 'Calculadora',
                          subtitle: 'Operaciones matemáticas',
                          icon: Icons.calculate_rounded,
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade400,
                              Colors.orange.shade700
                            ],
                          ),
                          onTap: () => Get.toNamed(AppRouter.calculadora),
                        ),

                        // 🎯 Información
                        AppCard(
                          title: 'Acerca de',
                          subtitle: 'Información del proyecto',
                          icon: Icons.info_outline,
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade400, Colors.blue.shade700],
                          ),
                          onTap: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Examen Final'),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('📱 Chat con IA',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('• Reacciones a mensajes'),
                                    Text('• Respuestas citadas'),
                                    Text('• Typing indicator'),
                                    Text('• Ticks de lectura'),
                                    SizedBox(height: 12),
                                    Text('🧮 Calculadora',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('• Operaciones básicas'),
                                    Text('• Porcentajes'),
                                    Text('• Números aleatorios'),
                                    Text('• Potencias'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Cerrar'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // 🔜 Próximamente
                        AppCard(
                          title: 'Próximamente',
                          subtitle: 'Más funciones...',
                          icon: Icons.add_circle_outline,
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade400,
                              Colors.grey.shade600
                            ],
                          ),
                          onTap: () {
                            Get.snackbar(
                              '¡Próximamente!',
                              'Más aplicaciones en desarrollo 🚀',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.teal,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                              duration: const Duration(seconds: 2),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

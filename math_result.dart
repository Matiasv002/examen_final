import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:examen_final/presentacion/controladores/calculadora_controlador.dart';

class MathResults extends StatelessWidget {
  final calculatorCtrl = Get.find<CalculadoraControlador>();

  MathResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            // Muestra el primer número y la operación
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${calculatorCtrl.firstNumber.value} ${calculatorCtrl.operation.value}',
                style: const TextStyle(fontSize: 30, color: Colors.white54),
              ),
            ),
            // Muestra el segundo número
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                calculatorCtrl.secondNumber.value,
                style: const TextStyle(fontSize: 30, color: Colors.white54),
              ),
            ),
            // Línea divisora
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Colors.white38),
            ),
            const SizedBox(height: 10),
            // Muestra el resultado principal
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                calculatorCtrl.mathResult.value,
                style: const TextStyle(fontSize: 65, color: Colors.white),
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
            ),
          ],
        ));
  }
}

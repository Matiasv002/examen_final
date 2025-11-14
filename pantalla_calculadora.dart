import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:examen_final/presentacion/controladores/calculadora_controlador.dart';
import 'package:examen_final/presentacion/widgets/calculator/math_result.dart';
import 'package:examen_final/presentacion/widgets/calculator/cal_button.dart';

class PantallaCalculadora extends StatelessWidget {
  final calculatorCtrl = Get.put(CalculadoraControlador());

  PantallaCalculadora({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              // Espacio superior
              Expanded(child: Container()),

              // Muestra del resultado
              MathResults(),

              // FILA 1: C, ( ), %, ÷
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CalculatorButton(
                      text: 'C',
                      bgColor: const Color(0xffA5A5A5),
                      onPressed: () => calculatorCtrl.resetAll(),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '( )',
                      bgColor: const Color(0xffA5A5A5),
                      onPressed: () {
                        // Función para paréntesis (opcional)
                        Get.snackbar(
                          'Función no disponible',
                          'Paréntesis proximamente',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 1),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '%',
                      bgColor: const Color(0xffA5A5A5),
                      onPressed: () => calculatorCtrl.applyPercentageToCurrent(),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '÷',
                      bgColor: const Color(0xffF0A23B),
                      onPressed: () => calculatorCtrl.selectOperation('/'),
                    ),
                  ),
                ],
              ),

              // FILA 2: 7, 8, 9, X
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CalculatorButton(
                      text: '7',
                      onPressed: () => calculatorCtrl.addNumber('7'),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '8',
                      onPressed: () => calculatorCtrl.addNumber('8'),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '9',
                      onPressed: () => calculatorCtrl.addNumber('9'),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: 'X',
                      bgColor: const Color(0xffF0A23B),
                      onPressed: () => calculatorCtrl.selectOperation('X'),
                    ),
                  ),
                ],
              ),

              // FILA 3: 4, 5, 6, -
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CalculatorButton(
                      text: '4',
                      onPressed: () => calculatorCtrl.addNumber('4'),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '5',
                      onPressed: () => calculatorCtrl.addNumber('5'),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '6',
                      onPressed: () => calculatorCtrl.addNumber('6'),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '-',
                      bgColor: const Color(0xffF0A23B),
                      onPressed: () => calculatorCtrl.selectOperation('-'),
                    ),
                  ),
                ],
              ),

              // FILA 4: 1, 2, 3, +
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CalculatorButton(
                      text: '1',
                      onPressed: () => calculatorCtrl.addNumber('1'),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '2',
                      onPressed: () => calculatorCtrl.addNumber('2'),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '3',
                      onPressed: () => calculatorCtrl.addNumber('3'),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '+',
                      bgColor: const Color(0xffF0A23B),
                      onPressed: () => calculatorCtrl.selectOperation('+'),
                    ),
                  ),
                ],
              ),

              // FILA 5: 0, ., =, xⁿ (potencia)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CalculatorButton(
                      text: '0',
                      onPressed: () => calculatorCtrl.addNumber('0'),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '.',
                      onPressed: () => calculatorCtrl.addDecimalPoint(),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: '=',
                      bgColor: const Color(0xffF0A23B),
                      onPressed: () => calculatorCtrl.calculateResult(),
                    ),
                  ),
                  Expanded(
                    child: CalculatorButton(
                      text: 'xⁿ',
                      bgColor: const Color(0xffA5A5A5),
                      onPressed: () {
                        // Función de potencia
                        Get.snackbar(
                          'Potencia',
                          'Ingresa la base, presiona xⁿ, luego el exponente y =',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                        calculatorCtrl.selectOperation('^');
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:get/get.dart';
import 'dart:math' as math;

class CalculadoraControlador extends GetxController {
  // Observables para actualizar la UI automáticamente
  var firstNumber = '0'.obs;
  var secondNumber = '0'.obs;
  var mathResult = '0'.obs;
  var operation = '+'.obs;

  // Reinicia todos los valores
  void resetAll() {
    firstNumber.value = '0';
    secondNumber.value = '0';
    mathResult.value = '0';
    operation.value = '+';
  }

  // Agrega números al resultado actual
  void addNumber(String number) {
    if (mathResult.value == '0') {
      mathResult.value = number;
    } else {
      mathResult.value += number;
    }
  }

  // Agrega punto decimal si no existe
  void addDecimalPoint() {
    if (mathResult.contains('.')) return;

    if (mathResult.startsWith('0')) {
      mathResult.value = '0.';
    } else {
      mathResult.value = '${mathResult.value}.';
    }
  }

  // Cambia el signo del número actual (+/-)
  void changeNegativePositive() {
    if (mathResult.startsWith('-')) {
      mathResult.value = mathResult.value.replaceFirst('-', '');
    } else {
      mathResult.value = '-${mathResult.value}';
    }
  }

  // Elimina el último carácter
  void deleteLastEntry() {
    if (mathResult.value.replaceAll('-', '').length > 1) {
      mathResult.value =
          mathResult.value.substring(0, mathResult.value.length - 1);
    } else {
      mathResult.value = '0';
    }
  }

  // Guarda la operación seleccionada y primer número
  void selectOperation(String newOperation) {
    operation.value = newOperation;
    firstNumber.value = mathResult.value;
    mathResult.value = '0';
  }

  // Aplica porcentaje al número actual (divide por 100)
  void applyPercentageToCurrent() {
    final value = double.tryParse(mathResult.value) ?? 0.0;
    mathResult.value = '${value / 100}';

    if (mathResult.value.endsWith('.0')) {
      mathResult.value =
          mathResult.value.substring(0, mathResult.value.length - 2);
    }
  }

  // Eleva al cuadrado el número actual
  void squareCurrentNumber() {
    final value = double.tryParse(mathResult.value) ?? 0.0;
    mathResult.value = '${value * value}';

    if (mathResult.value.endsWith('.0')) {
      mathResult.value =
          mathResult.value.substring(0, mathResult.value.length - 2);
    }
  }

  // Calcula el resultado final según la operación
  void calculateResult() {
    double num1 = double.tryParse(firstNumber.value) ?? 0.0;
    double num2 = double.tryParse(mathResult.value) ?? 0.0;

    secondNumber.value = mathResult.value;

    switch (operation.value) {
      case '+':
        mathResult.value = '${num1 + num2}';
        break;
      case '-':
        mathResult.value = '${num1 - num2}';
        break;
      case 'X':
      case '*':
        mathResult.value = '${num1 * num2}';
        break;
      case '/':
        if (num2 != 0) {
          mathResult.value = '${num1 / num2}';
        } else {
          mathResult.value = 'Error';
        }
        break;
      case '%':
        // Porcentaje del primer número respecto al segundo
        mathResult.value = '${num1 * num2 / 100}';
        break;
      case '^':
        // Potencia: num1 elevado a num2
        mathResult.value = '${math.pow(num1, num2)}';
        break;
      default:
        return;
    }

    // Si termina en .0, lo quita
    if (mathResult.value.endsWith('.0')) {
      mathResult.value =
          mathResult.value.substring(0, mathResult.value.length - 2);
    }
  }
}
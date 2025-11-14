import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final Color bgColor;
  final bool big;
  final String text;
  final VoidCallback onPressed; // ✅ Tipo más seguro para funciones sin argumentos

  const CalculatorButton({
    super.key,
    this.bgColor = const Color(0xff333333), // Gris oscuro por defecto
    this.big = false,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: big ? 170 : 80, // ✅ Hace el botón más ancho si es "big"
      child: MaterialButton(
        height: 80,
        color: bgColor,
        shape: const StadiumBorder(),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

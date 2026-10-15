import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculatrice iOS',
      theme: ThemeData.dark(useMaterial3: true),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = "";
  String _output = "0";
  bool _isResultSet = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        _input = "";
        _output = "0";
        _isResultSet = false;
      } else if (buttonText == "⌫") {
        // Effacer le dernier caractère
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
          if (_input.isEmpty) {
            _output = "0";
          } else {
            _output = _input;
          }
        }
      } else if (buttonText == "+/-") {
        if (_input.startsWith("-")) {
          _input = _input.substring(1);
        } else {
          _input = "-$_input";
        }
        _output = _input;
      } else if (buttonText == "%") {
        if (_input.isNotEmpty) {
          _input = "($_input)/100";
          _calculateResult();
        }
      } else if (buttonText == "=") {
        _calculateResult();
        _isResultSet = true;
      } else {
        if (_isResultSet) {
          if ("0123456789.".contains(buttonText)) {
            _input = buttonText;
          } else {
            _input = _output + buttonText;
          }
          _isResultSet = false;
        } else {
          if (_output == "0" && buttonText != ".") {
            _input = buttonText;
          } else {
            _input = _input + buttonText;
          }
        }
        _output = _input;
      }
    });
  }

  void _calculateResult() {
    if (_input.isEmpty) return;

    String finalExpression = _input;
    finalExpression = finalExpression.replaceAll('×', '*');
    finalExpression = finalExpression.replaceAll('÷', '/');

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      String resultString = eval.toString();
      if (resultString.endsWith('.0')) {
        _output = resultString.substring(0, resultString.length - 2);
      } else {
        if (resultString.contains('.')) {
          List<String> parts = resultString.split('.');
          if (parts[1].length > 6) {
            _output = eval.toStringAsFixed(6);
            _output = _output.replaceAll(
              RegExp(r"([0-9]+(.?[0-9]*[1-9])?)0+$"),
              r"\1",
            );
            if (_output.endsWith('.')) {
              _output = _output.substring(0, _output.length - 1);
            }
          } else {
            _output = resultString;
          }
        } else {
          _output = resultString;
        }
      }
      _input = _output;
    } catch (e) {
      _output = "Erreur";
      _input = "";
    }
  }

  // Widget de bouton avec animation d'échelle subtile au clic (AnimatedScale)
  Widget _buildButton(
    String text,
    Color bgColor,
    Color textColor, {
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: AnimatedButton(
          text: text,
          bgColor: bgColor,
          textColor: textColor,
          isExtended: flex == 2,
          onPressed: () => _buttonPressed(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              children: <Widget>[
                // Écran d'affichage
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      _output,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 70.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Grille des boutons avec le bouton de suppression (⌫)
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              _buildButton(
                                "AC",
                                const Color(0xFFA5A5A5),
                                Colors.black,
                              ),
                              _buildButton(
                                "⌫",
                                const Color(0xFFA5A5A5),
                                Colors.black,
                              ), // Bouton d'effacement
                              _buildButton(
                                "%",
                                const Color(0xFFA5A5A5),
                                Colors.black,
                              ),
                              _buildButton(
                                "÷",
                                const Color(0xFFFF9F0A),
                                Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildButton(
                                "7",
                                const Color(0xFF333333),
                                Colors.white,
                              ),
                              _buildButton(
                                "8",
                                const Color(0xFF333333),
                                Colors.white,
                              ),
                              _buildButton(
                                "9",
                                const Color(0xFF333333),
                                Colors.white,
                              ),
                              _buildButton(
                                "×",
                                const Color(0xFFFF9F0A),
                                Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildButton(
                                "4",
                                const Color(0xFF333333),
                                Colors.white,
                              ),
                              _buildButton(
                                "5",
                                const Color(0xFF333333),
                                Colors.white,
                              ),
                              _buildButton(
                                "6",
                                const Color(0xFF333333),
                                Colors.white,
                              ),
                              _buildButton(
                                "-",
                                const Color(0xFFFF9F0A),
                                Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildButton(
                                "1",
                                const Color(0xFF333333),
                                Colors.white,
                              ),
                              _buildButton(
                                "2",
                                const Color(0xFF333333),
                                Colors.white,
                              ),
                              _buildButton(
                                "3",
                                const Color(0xFF333333),
                                Colors.white,
                              ),
                              _buildButton(
                                "+",
                                const Color(0xFFFF9F0A),
                                Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildButton(
                                "0",
                                const Color(0xFF333333),
                                Colors.white,
                                flex: 2,
                              ),
                              _buildButton(
                                ".",
                                const Color(0xFF333333),
                                Colors.white,
                              ),
                              _buildButton(
                                "=",
                                const Color(0xFFFF9F0A),
                                Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget indépendant pour gérer l'animation fluide de clic sur chaque bouton
class AnimatedButton extends StatefulWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final bool isExtended;
  final VoidCallback onPressed;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
    required this.isExtended,
    required this.onPressed,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0, // Effet d'enfoncement au clic
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: widget.bgColor,
            shape: widget.isExtended ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: widget.isExtended
                ? BorderRadius.circular(35.0)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w400,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}

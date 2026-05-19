import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  static const List<String> _buttons = [
    'C', '<-', '%', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', '=',
  ];

  String _display = '';
  double? _firstOperand;
  String? _operator;
  bool _newNumber = true;

  bool _isOperator(String x) =>
      x == '+' || x == '-' || x == '*' || x == '/' || x == '%';

  double _calculate(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return b != 0 ? a / b : 0;
      case '%':
        return a % b;
      default:
        return 0;
    }
  }

  void _onPressed(String label) {
    setState(() {
      // CLEAR
      if (label == 'C') {
        _display = '';
        _firstOperand = null;
        _operator = null;
        _newNumber = true;
        return;
      }

      // BACKSPACE
      if (label == '<-') {
        if (_display.isNotEmpty) {
          _display = _display.substring(0, _display.length - 1);
          if (_display.isEmpty) _newNumber = true;
        }
        return;
      }

      // DECIMAL
      if (label == '.') {
        if (_newNumber) {
          _display = '0.';
          _newNumber = false;
        } else if (!_display.contains('.')) {
          _display += '.';
        }
        return;
      }

      // EQUALS
      if (label == '=') {
        if (_firstOperand != null &&
            _operator != null &&
            _display.isNotEmpty) {
          double second = double.tryParse(_display) ?? 0;

          double result = _calculate(_firstOperand!, second, _operator!);

          _display = result % 1 == 0
              ? result.toInt().toString()
              : result.toString();

          _firstOperand = null;
          _operator = null;
          _newNumber = true;
        }
        return;
      }

      // OPERATORS
      if (_isOperator(label)) {
        if (_display.isNotEmpty) {
          double current = double.tryParse(_display) ?? 0;

          // if already have operator → calculate first (real calculator behavior)
          if (_firstOperand != null && _operator != null && !_newNumber) {
            _firstOperand = _calculate(_firstOperand!, current, _operator!);
            _display = _firstOperand.toString();
          } else {
            _firstOperand = current;
          }

          _operator = label;
          _newNumber = true;
        }
        return;
      }

      // NUMBERS
      if (_newNumber) {
        _display = label;
        _newNumber = false;
      } else {
        _display += label;
      }
    });
  }

  bool _isOp(String x) => _isOperator(x);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // DISPLAY
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.all(12),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _display.isEmpty ? '0' : _display,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // KEYPAD
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: _buttons.map((label) {
                  final isOperator = _isOp(label);

                  return ElevatedButton(
                    onPressed: () => _onPressed(label),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: label == '='
                          ? Colors.blue.shade900
                          : isOperator
                              ? Colors.blue.shade600
                              : Colors.blue.shade100,
                      foregroundColor: label == '=' || isOperator
                          ? Colors.white
                          : Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 26),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
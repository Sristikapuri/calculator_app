import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  static const List<String> _buttons = [
    'C',
    '*',
    '/',
    '<-',
    '1',
    '2',
    '3',
    '+',
    '4',
    '5',
    '6',
    '-',
    '7',
    '8',
    '9',
    '*',
    '%',
    '0',
    '.',
    '=',
  ];

  String _display = '';
  double? _firstOperand;
  String? _operator;
  bool _newNumber = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.all(12),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _display,
                style: TextStyle(fontSize: 28, color: Colors.blue.shade900),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
                children: [
                  for (final label in _buttons)
                    ElevatedButton(
                      onPressed: () {
                        if (label == 'C') {
                          setState(() {
                            _display = '';
                            _firstOperand = null;
                            _operator = null;
                            _newNumber = true;
                          });
                        } else if (label == '<-') {
                          if (_display.isNotEmpty) {
                            setState(() {
                              _display = _display.substring(
                                0,
                                _display.length - 1,
                              );
                              if (_display.isEmpty) {
                                _newNumber = true;
                              }
                            });
                          }
                        } else if (label == '=') {
                          if (_firstOperand != null && _operator != null && _display.isNotEmpty) {
                            double secondOperand = double.tryParse(_display) ?? 0;
                            double result;
                            switch (_operator) {
                              case '+':
                                result = _firstOperand! + secondOperand;
                                break;
                              case '-':
                                result = _firstOperand! - secondOperand;
                                break;
                              case '*':
                                result = _firstOperand! * secondOperand;
                                break;
                              case '/':
                                result = secondOperand != 0 ? _firstOperand! / secondOperand : 0;
                                break;
                              case '%':
                                result = _firstOperand! % secondOperand;
                                break;
                              default:
                                result = 0;
                            }
                            setState(() {
                              _display = result % 1 == 0 ? result.toInt().toString() : result.toString();
                              _firstOperand = null;
                              _operator = null;
                              _newNumber = true;
                            });
                          }
                        } else if ('+-*/%'.contains(label)) {
                          if (_display.isNotEmpty) {
                            _firstOperand = double.tryParse(_display);
                            _operator = label;
                            _newNumber = true;
                          }
                        } else {
                          if (_newNumber) {
                            setState(() {
                              _display = label;
                              _newNumber = false;
                            });
                          } else {
                            setState(() => _display += label);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: '+-*/%'.contains(label) ? Colors.blue.shade700 : Colors.blue.shade100,
                        foregroundColor: '+-*/%'.contains(label) ? Colors.white : Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(label, style: const TextStyle(fontSize: 28)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

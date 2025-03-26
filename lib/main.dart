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
      theme: ThemeData.dark(),
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
  String input = '';
  String output = '';
  bool isDarkMode = true;

  final List<String> buttons = [
    'AC', '⌫', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '−',
    '1', '2', '3', '+',
    '0','00', '.', '=',
  ];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        input = '';
        output = '';
      } else if (value == '⌫') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == '=') {
        try {
          String formattedInput = input.replaceAll('×', '*').replaceAll('÷', '/');
          formattedInput = formattedInput.replaceAllMapped(RegExp(r'(\d+)%'), (match) {
            return (double.parse(match[1]!) / 100).toString();
          });
          Parser p = Parser();
          Expression exp = p.parse(formattedInput);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          output = eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 2);
        } catch (e) {
          output = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[1000] : Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // Bagian atas (Tombol Tema & Output/Input)
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tombol Toggle Theme
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wb_sunny, color: isDarkMode ? Colors.white54 : Colors.black54),
                      Switch(
                        value: isDarkMode,
                        activeColor: Colors.orange,
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            isDarkMode = value;
                          });
                        },
                      ),
                      Icon(Icons.nightlight_round, color: isDarkMode ? Colors.white54 : Colors.black54),
                    ],
                  ),
                  // Tampilan Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        input.isEmpty ? '0' : input,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  // Tampilan Output
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        output,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bagian bawah (Tombol Angka & Operator)
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.grey[300],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded( // Fix overflow dengan Expanded
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: buttons.length,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                            onPressed: () => _onButtonPressed(buttons[index]),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: _getButtonColor(buttons[index]),
                              padding: EdgeInsets.all(16),
                            ),
                            child: Text(
                              buttons[index],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _getTextColor(buttons[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getButtonColor(String value) {
    if (['AC', '⌫', '%'].contains(value)) {
      return Colors.redAccent;
    } else if (['÷', '×', '−', '+', '='].contains(value)) {
      return Colors.orange;
    } else {
      return isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    }
  }

  Color _getTextColor(String value) {
    if (['AC', '⌫', '%'].contains(value)) {
      return Colors.white;
    } else if (['÷', '×', '−', '+', '='].contains(value)) {
      return Colors.white;
    } else {
      return isDarkMode ? Colors.white : Colors.black;
    }
  }
}

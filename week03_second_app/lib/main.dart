import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff1f1f1f),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0', expression = '';
  double? left;
  String? operation;
  bool fresh = false;

  final keys = const [
    'C', '⌫', '%', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', '+/-', '=',
  ];

  void press(String key) {
    setState(() {
      if (key == 'C') {
        display = '0'; expression = ''; left = null; operation = null; fresh = false;
      } else if (key == '⌫') {
        display = display.length > 1 ? display.substring(0, display.length - 1) : '0';
      } else if (key == '+/-') {
        if (display != '0') {
          display = display.startsWith('-') ? display.substring(1) : '-$display';
        }
      } else if (key == '%') {
        final value = double.tryParse(display) ?? 0;
        display = format(value / 100);
      } else if ('0123456789.'.contains(key)) {
        if (fresh || display == '0') {
          display = key == '.' ? '0.' : key;
          fresh = false;
        } else if (key != '.' || !display.contains('.')) {
          display += key;
        }
      } else if ('+-*/'.contains(key)) {
        left = double.tryParse(display) ?? 0;
        operation = key; expression = '$display $key'; fresh = true;
      } else if (key == '=') {
        calculate();
      }
    });
  }

  void calculate() {
    if (left == null || operation == null) return;
    final right = double.tryParse(display) ?? 0;
    final result = operation == '+' ? left! + right : operation == '-' ? left! - right : operation == '*' ? left! * right : (right == 0 ? 0.0 : left! / right);
    expression = '$expression ${format(right)} =';
    display = format(result); left = null; operation = null; fresh = true;
  }

  String format(double value) => value == value.roundToDouble() ? value.toInt().toString() : value.toString();

  Color _buttonColor(String key) {
    if ('+-*/='.contains(key)) return const Color(0xfff28c28);
    if (key == 'C' || key == '⌫' || key == '%') return const Color(0xff55565a);
    return const Color(0xff292a2e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff101114),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420, maxHeight: 760),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                      decoration: BoxDecoration(
                        color: const Color(0xff191a1e),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            expression,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              display,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        for (var row = 0; row < 5; row++) ...[
                          if (row > 0) const SizedBox(height: 10),
                          Expanded(
                            child: Row(
                              children: [
                                for (var column = 0; column < 4; column++) ...[
                                  if (column > 0) const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildButton(keys[row * 4 + column]),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String key) {
    return ElevatedButton(
      onPressed: () => press(key),
      style: ElevatedButton.styleFrom(
        backgroundColor: _buttonColor(key),
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          key,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
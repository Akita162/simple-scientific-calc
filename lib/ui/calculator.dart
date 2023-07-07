import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';

  final List<String> _buttonOrder = [
    'C',
    '()',
    '%',
    '<=',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    '\u00d7',
    '1',
    '2',
    '3',
    '-',
    '.',
    '0',
    '=',
    '+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: Text(
                _input,
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: _buttonOrder.length,
                itemBuilder: (BuildContext context, int index) {
                  final buttonText = _buttonOrder[index];
                  return buildButton(buttonText);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: () => _buttonPressed(text),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  _buttonPressed(String buttonString) {
    setState(() {
      String lastInput =
          _input.isNotEmpty ? _input.substring(_input.length - 1) : '';

      // [int.tryParse(string) != null] is .isNumber()
      // if (int.tryParse(buttonString) != null ||
      //     buttonString.contains(RegExp(r'[-+/]'))) {
      //   _input += buttonString;
      // } else
      if (buttonString == 'C' || _input == 'Error') {
        _input = '';
      } else if (buttonString == '( )') {
        if (_input.isNotEmpty && int.tryParse(lastInput) != null) {
          _input += '*(';
        } else if (_input.contains('(') && lastInput != '(') {
          _input += ')';
        } else {
          _input += '(';
        }
      } else if (buttonString == '%') {
        if (_input.isNotEmpty && int.tryParse(lastInput) != null) _input += '%';
      } else if (buttonString == '<=') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (buttonString == '\u00d7') {
        _input += '*';
      } else if (buttonString == '=') {
        if (_input.isNotEmpty && int.tryParse(lastInput) != null) {
          _input = _evalMath(_input);
        }
      } else if (buttonString == '.') {
        if (_input.isEmpty) {
          _input += '0.';
        } else if (int.tryParse(lastInput) != null) {
          _input += '.';
        }
      } else {
        _input += buttonString;
      }
    });
  }

  _evalMath(String formula) {
    double result;

    try {
      Expression exp = Parser().parse(formula);
      result = exp.evaluate(EvaluationType.REAL, ContextModel());
    } catch (e) {
      result = double.nan;
    }

    String output = result.isNaN ? 'Error' : result.toString();
    return output;
  }
}

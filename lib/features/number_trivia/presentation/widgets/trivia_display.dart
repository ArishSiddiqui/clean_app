import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia trivia;
  const TriviaDisplay({
    required this.trivia,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            trivia.number.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 45.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  trivia.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

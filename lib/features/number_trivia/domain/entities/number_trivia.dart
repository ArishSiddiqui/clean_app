// This is the first editale file
// Basically this file will contain a structure that,
// what data or fields our json response consist of.

// Let say we have response :
// {
//   "text": "Some Info about number 80",
//   "number": 80,
// }
// So for this response our file will be like

import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;

  const NumberTrivia({
    required this.text,
    required this.number,
  });

  @override
  List<Object> get props => [text, number];
}

import 'package:clean_app/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter? inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('strinToUnsignedInt', () {
    test(
      'should return an int when string represents an unsigned integer',
      () async {
        // arrange
        const str = '123';
        // act
        final result = inputConverter!.stringToUnsignedInteger(str);
        // assert
        expect(result, const Right(123));
      },
    );

    test(
      'should return a Failure when the String is not an integer',
      () async {
        // arrange
        const str = 'abc';
        // act
        final result = inputConverter!.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return a Failure when the string is negative integer',
      () async {
        // arrange
        const str = '-123';
        // act
        final result = inputConverter!.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}

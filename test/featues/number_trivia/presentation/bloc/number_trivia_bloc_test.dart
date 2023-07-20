import 'package:clean_app/core/util/input_converter.dart';
import 'package:clean_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivai extends Mock
    implements GetConcreteNumberTrivai {}

class MockGetRandomNumberTrivai extends Mock implements GetRandomNumberTrivai {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc? bloc;
  MockGetConcreteNumberTrivai? mockGetConcreteNumberTrivai;
  MockGetRandomNumberTrivai? mockGetRandomNumberTrivai;
  MockInputConverter? mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivai = MockGetConcreteNumberTrivai();
    mockGetRandomNumberTrivai = MockGetRandomNumberTrivai();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivai!,
      random: mockGetRandomNumberTrivai!,
      inputConverter: mockInputConverter!,
    );
  });

  test('initialState should be Empty', () {
    // assert
    // expect(bloc., matcher)
  });
}

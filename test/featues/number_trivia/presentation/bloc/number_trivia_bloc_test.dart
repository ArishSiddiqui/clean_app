import 'package:clean_app/core/error/failure.dart';
import 'package:clean_app/core/usecases/usecase.dart';
import 'package:clean_app/core/util/input_converter.dart';
import 'package:clean_app/features/number_trivia/domain/entities/number_trivia.dart';
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
  late MockGetConcreteNumberTrivai mockGetConcreteNumberTrivai;
  late MockGetRandomNumberTrivai mockGetRandomNumberTrivai;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivai = MockGetConcreteNumberTrivai();
    mockGetRandomNumberTrivai = MockGetRandomNumberTrivai();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivai,
      random: mockGetRandomNumberTrivai,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc!.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(tNumberString))
            .thenReturn(const Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        // act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            mockInputConverter.stringToUnsignedInteger(tNumberString));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async* {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(tNumberString))
            .thenReturn(Left(InvalidInputFailure()));
        // assert
        final expected = [
          Empty(),
          const Error(message: invalidInputFailureMessage),
        ];
        expectLater(bloc!.state, emitsInOrder(expected));
        // act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    // End of 11th Tutorial

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivai(const Params(number: tNumberParsed)))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            mockGetConcreteNumberTrivai(const Params(number: tNumberParsed)));
        // assert
        verify(
            mockGetConcreteNumberTrivai(const Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async* {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivai(const Params(number: tNumberParsed)))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // assert Later
        final expected = [
          Empty(),
          Loading(),
          const Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc!.state, emitsInOrder(expected));
        // act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async* {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivai(const Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert Later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: serverFailureMessage),
        ];
        expectLater(bloc!.state, emitsInOrder(expected));
        // act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async* {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivai(const Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert Later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: cacheFailureMessage),
        ];
        expectLater(bloc!.state, emitsInOrder(expected));
        // act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivai(NoParams()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc!.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivai(NoParams()));
        // assert
        verify(mockGetRandomNumberTrivai(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async* {
        // arrange
        when(mockGetRandomNumberTrivai(NoParams()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // assert Later
        final expected = [
          Empty(),
          Loading(),
          const Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc!.state, emitsInOrder(expected));
        // act
        bloc!.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async* {
        // arrange
        when(mockGetRandomNumberTrivai(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert Later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: serverFailureMessage),
        ];
        expectLater(bloc!.state, emitsInOrder(expected));
        // act
        bloc!.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async* {
        // arrange
        when(mockGetRandomNumberTrivai(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert Later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: cacheFailureMessage),
        ];
        expectLater(bloc!.state, emitsInOrder(expected));
        // act
        bloc!.add(GetTriviaForRandomNumber());
      },
    );
  });
}

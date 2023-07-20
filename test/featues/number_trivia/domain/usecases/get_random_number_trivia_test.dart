import 'package:clean_app/core/usecases/usecase.dart';
import 'package:clean_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivai? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  // setup() is a method that runs before every test.
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivai(mockNumberTriviaRepository!);
  });

  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test(
    'should get trivia from the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository!.getRandomNumberTrivai())
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      // final result = await usecase!.execute(number: tNumber);
      // we can call our callable method without naming a method. 
      final result = await usecase!(NoParams());
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository!.getRandomNumberTrivai());
      verifyNoMoreInteractions(mockNumberTriviaRepository!);
    },
  );
}

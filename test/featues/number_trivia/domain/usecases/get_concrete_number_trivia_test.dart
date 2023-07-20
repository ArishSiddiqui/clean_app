import 'package:clean_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivai? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  // setup() is a method that runs before every test.
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivai(mockNumberTriviaRepository!);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository!.getConcreteNumberTrivai(1))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      // final result = await usecase!.execute(number: tNumber);
      // we can call our callable method without naming a method. 
      final result = await usecase!(const Params(number: tNumber));
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository!.getConcreteNumberTrivai(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository!);
    },
  );
}

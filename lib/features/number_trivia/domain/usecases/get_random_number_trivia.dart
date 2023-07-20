import 'package:clean_app/core/error/failure.dart';
import 'package:clean_app/core/usecases/usecase.dart';
import 'package:clean_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivai implements Usecase<NumberTrivia?, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivai(this.repository);

  @override
  Future<Either<Failure, NumberTrivia?>> call(NoParams params) async {
    return await repository.getRandomNumberTrivai()!;
  }
}

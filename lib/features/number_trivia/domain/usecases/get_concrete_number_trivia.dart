// import 'package:clean_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_app/core/error/failure.dart';
import 'package:clean_app/core/usecases/usecase.dart';
import 'package:clean_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivai implements Usecase<NumberTrivia?, Params> {
  final NumberTriviaRepository repository;
  GetConcreteNumberTrivai(this.repository);

  // Instead of Creating execute method we can use a method name call, which will directly make this method callable in our test
  // Future<Either<Failure, NumberTrivia>> execute({
  //   required int number,
  // }) async {
  //   return await repository.getConcreteNumberTrivai(number)!;
  // }
  // we can define this method like this
  @override
  Future<Either<Failure, NumberTrivia?>> call(Params params) async {
    return await repository.getConcreteNumberTrivai(params.number)!;
  }
}

class Params extends Equatable {
  final int number;
  const Params({required this.number});

  @override
  List<Object> get props => [number];
}

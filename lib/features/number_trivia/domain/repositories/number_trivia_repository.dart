// Instead of Importing Packages like this,
// import 'package:clean_app/core/error/failure.dart';
// import 'package:clean_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
// Trainer has taught us to import package like this
import '../../../../core/error/failure.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia?>>? getConcreteNumberTrivai(int number);
  Future<Either<Failure, NumberTrivia?>>? getRandomNumberTrivai();
}
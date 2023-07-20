import 'package:clean_app/core/error/exceptions.dart';
import 'package:clean_app/core/network/network_info.dart';
import 'package:clean_app/features/number_trivia/data/models/number_trivia_model.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';
import 'package:clean_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_app/core/error/failure.dart';
import 'package:clean_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

// This is How tutor has taught us
// typedef Future<NumberTriviaModel?>? _ConcreteOrRandomChooser();
// This is the preferred way recommendded by Flutter
typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel?>? Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia?>>? getConcreteNumberTrivai(
    int number,
  ) async {
    return await _getTrivia(() => remoteDataSource.getConcreteNumberTrivai(number))!;
  }

  @override
  Future<Either<Failure, NumberTrivia?>>? getRandomNumberTrivai() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivai())!;
  }

  Future<Either<Failure, NumberTrivia?>>? _getTrivia(
    _ConcreteOrRandomChooser getConcreteorRandom,
  ) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteTrivia = await getConcreteorRandom();
        localDataSource.cachedNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

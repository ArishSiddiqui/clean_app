import 'package:clean_app/core/error/exceptions.dart';
import 'package:clean_app/core/error/failure.dart';
import 'package:clean_app/core/network/network_info.dart';
import 'package:clean_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl? repository;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource!,
      localDataSource: mockLocalDataSource!,
      networkInfo: mockNetworkInfo!,
    );
  });
  // Till here the 5th Part of Tutorial get completes

  // void runTestOnline(Function body) {
  //   group('device is online', () {
  //     setUp(() {
  //       when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
  //     });

  //     body();
  //   });
  // }

  // void runTestOffline(Function body) {
  //   group('device is offline', () {
  //     setUp(() {
  //       when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
  //     });

  //     body();
  //   });
  // }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Trivia', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if device is online',
      () async {
        // assert
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
        // act
        repository!.getConcreteNumberTrivai(tNumber);
        // assert
        verify(mockNetworkInfo!.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource!.getConcreteNumberTrivai(1))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository!.getConcreteNumberTrivai(tNumber);
          // assert
          verify(mockRemoteDataSource!.getConcreteNumberTrivai(tNumber));
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource!.getConcreteNumberTrivai(1))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository!.getConcreteNumberTrivai(tNumber);
          // assert
          verify(mockRemoteDataSource!.getConcreteNumberTrivai(tNumber));
          verify(mockLocalDataSource!.cachedNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDataSource!.getConcreteNumberTrivai(1))
              .thenThrow(ServerException());
          // act
          final result = await repository!.getConcreteNumberTrivai(tNumber);
          // assert
          verify(mockRemoteDataSource!.getConcreteNumberTrivai(tNumber));
          verifyNoMoreInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource!.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository!.getConcreteNumberTrivai(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should return CachedFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource!.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository!.getConcreteNumberTrivai(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Trivia', number: 123);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if device is online',
      () async {
        // assert
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
        // act
        repository!.getRandomNumberTrivai();
        // assert
        verify(mockNetworkInfo!.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource!.getRandomNumberTrivai())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository!.getRandomNumberTrivai();
          // assert
          verify(mockRemoteDataSource!.getRandomNumberTrivai());
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource!.getRandomNumberTrivai())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository!.getRandomNumberTrivai();
          // assert
          verify(mockRemoteDataSource!.getRandomNumberTrivai());
          verify(mockLocalDataSource!.cachedNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDataSource!.getRandomNumberTrivai())
              .thenThrow(ServerException());
          // act
          final result = await repository!.getRandomNumberTrivai();
          // assert
          verify(mockRemoteDataSource!.getRandomNumberTrivai());
          verifyNoMoreInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource!.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository!.getRandomNumberTrivai();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should return CachedFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource!.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository!.getRandomNumberTrivai();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}

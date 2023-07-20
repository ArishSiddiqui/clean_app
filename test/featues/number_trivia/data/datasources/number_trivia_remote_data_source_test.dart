import 'dart:convert';

import 'package:clean_app/core/error/exceptions.dart';
import 'package:clean_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

// class MockHttpClient extends Mock implements http.Client {}

@GenerateMocks([http.Client])
void main() {
  NumberTriviaRemoteDataSourceImpl? dataSource;
  MockClient? mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient!);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient!.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient!.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group(
    'getConcreteNumberTrivia',
    () {
      const tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

      test(
        'should perform a GET request on a URL with number being the endpoint and with application/json hearder',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          dataSource!.getConcreteNumberTrivai(tNumber);
          // assert
          verify(mockHttpClient!.get(
            any,
            headers: {
              'Content-Type': 'application/json',
            },
          ));
        },
      );

      test(
        'should return a NumberTrivia when the response code is 200 (success)',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          final result = await dataSource!.getConcreteNumberTrivai(tNumber);
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should throw a ServerException when status code is 404 or other',
        () async {
          // arrange
          // First we have created & tested function like this. Afterward we have converted it to a Function,
          // where we are calling test -> setUpMockHttpClientFailure404()
          // when(mockHttpClient!.get(url, headers: anyNamed('headers')))
          //     .thenAnswer(
          //   (_) async => http.Response('Something went wrong', 404),
          // );
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource!.getConcreteNumberTrivai;
          // assert
          expect(() => call(tNumber),
              throwsA(const TypeMatcher<ServerException>()));
        },
      );
    },
  );

  group(
    'getRandomNumberTrivia',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

      test(
        'should perform a GET request on a URL with number being the endpoint and with application/json hearder',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          dataSource!.getRandomNumberTrivai();
          // assert
          verify(mockHttpClient!.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {
              'Content-Type': 'application/json',
            },
          ));
        },
      );

      test(
        'should return a NumberTrivia when the response code is 200 (success)',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          final result = await dataSource!.getRandomNumberTrivai();
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should throw a ServerException when status code is 404 or other',
        () async {
          // arrange
          // First we have created & tested function like this. Afterward we have converted it to a Function,
          // where we are calling test -> setUpMockHttpClientFailure404()
          // when(mockHttpClient!.get(url, headers: anyNamed('headers')))
          //     .thenAnswer(
          //   (_) async => http.Response('Something went wrong', 404),
          // );
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource!.getRandomNumberTrivai;
          // assert
          expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
        },
      );
    },
  );
}

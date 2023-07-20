import 'dart:convert';
import 'package:clean_app/core/error/exceptions.dart';
import 'package:clean_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

// class MockSharedPreferences extends Mock implements SharedPreferences {}

// @GenerateMocks([SharedPreferences])
// at Some place it need @GenerateMocks and at some place it need @GenerateNiceMocks, 
//in this case over here we used @GenerateNiceMocks to get perfect result.
@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  NumberTriviaLocalDataSourceImpl? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences!);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from SharedPreferences when there is one in cache',
      () async {
        // arrange
        when(mockSharedPreferences!.getString(cacheNumberTrivia))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource!.getLastNumberTrivia();
        // assert
        verify(mockSharedPreferences!.getString(cacheNumberTrivia));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw CacheException when there is no cached value',
      () async {
        // arrange
        when(mockSharedPreferences!.getString(cacheNumberTrivia))
            .thenReturn(null);
        // act
        final call = dataSource!.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Trivia', number: 1);

    test(
      'should call SharedPreferences to Cache the data',
      () async {
        // act
        dataSource!.cachedNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(mockSharedPreferences!.setString(
          cacheNumberTrivia,
          expectedJsonString,
        ));
      },
    );
  });
}

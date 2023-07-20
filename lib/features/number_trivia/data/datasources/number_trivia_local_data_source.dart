import 'dart:convert';

import 'package:clean_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// when the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel>? getLastNumberTrivia();

  Future<bool>? cachedNumberTrivia(NumberTriviaModel? triviaToCache);
}

// Tutor has taught us in this way
// const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';
// but we are following camel casing recommended by VS code
const cacheNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel>? getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(cacheNumberTrivia);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool>? cachedNumberTrivia(NumberTriviaModel? triviaToCache) {
    return sharedPreferences.setString(
      cacheNumberTrivia,
      json.encode(triviaToCache!.toJson()),
    );
  }
}

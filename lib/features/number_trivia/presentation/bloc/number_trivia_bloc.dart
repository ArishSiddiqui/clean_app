import 'package:bloc/bloc.dart';
import 'package:clean_app/core/util/input_converter.dart';
import 'package:clean_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivai getConcreteNumberTrivai;
  final GetRandomNumberTrivai getRandomNumberTrivai;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivai concrete,
    required GetRandomNumberTrivai random,
    required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivai = concrete,
        getRandomNumberTrivai = random,
        super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
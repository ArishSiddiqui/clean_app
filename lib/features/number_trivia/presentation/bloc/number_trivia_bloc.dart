// import 'package:bloc/bloc.dart';
import 'package:clean_app/core/error/failure.dart';
import 'package:clean_app/core/usecases/usecase.dart';
import 'package:clean_app/core/util/input_converter.dart';
import 'package:clean_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaState get initialState => Empty();

  final GetConcreteNumberTrivai getConcreteNumberTrivai;
  final GetRandomNumberTrivai getRandomNumberTrivai;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivai concrete,
    required GetRandomNumberTrivai random,
    required this.inputConverter,
  })  :
        // assert(concrete != null),
        // assert(random != null),
        // assert(inputConverter != null),
        // We don't need this line in Updated Flutter Version.
        getConcreteNumberTrivai = concrete,
        getRandomNumberTrivai = random,
        super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        inputEither!.fold(
          // This Method was written in tutor's explanation.
          // (failure) async* {
          //   yield const Error(message: invalidInputFailureMessage);
          // },
          // Correct way of implementation
          (failure) => emit(const Error(message: invalidInputFailureMessage)),
          (integer) async {
            emit(Loading());
            final failureOrTrivia =
                await getConcreteNumberTrivai(Params(number: integer));
            _eitherLoadedOrErrorState(emit, failureOrTrivia);
            // failureOrTrivia?.fold(
            //   (failure) => emit(
            //     Error(message: _mapFailureToMessage(failure)),
            //   ),
            //   (trivia) => emit(Loaded(trivia: trivia!)),
            // );
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivai(NoParams());
        _eitherLoadedOrErrorState(emit, failureOrTrivia);
        // failureOrTrivia?.fold(
        //   (failure) => emit(
        //     Error(message: _mapFailureToMessage(failure)),
        //   ),
        //   (trivia) => emit(Loaded(trivia: trivia!)),
        // );
      }
    });
  }
}

_eitherLoadedOrErrorState(
  Emitter<NumberTriviaState> emit,
  Either<Failure, NumberTrivia?>? failureOrTrivia,
) {
  failureOrTrivia?.fold(
    (failure) => emit(
      Error(message: _mapFailureToMessage(failure)),
    ),
    (trivia) => emit(Loaded(trivia: trivia!)),
  );
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return serverFailureMessage;
    case CacheFailure:
      return cacheFailureMessage;
    default:
      return 'Unexpected Error';
  }
}

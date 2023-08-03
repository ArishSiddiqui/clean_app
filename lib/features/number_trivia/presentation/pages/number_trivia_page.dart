import 'package:clean_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Error) {
                  return MessageDisplay(
                    message: state.message,
                  );
                } else if (state is Loading) {
                  return const LoaderWidget();
                } else if (state is Loaded) {
                  return TriviaDisplay(trivia: state.trivia);
                }
                return const MessageDisplay(
                  message: 'Start Searching...',
                );
              },
            ),
            const SizedBox(height: 20.0),
            const TriviaControls()
          ],
        ),
      ),
    );
  }
}

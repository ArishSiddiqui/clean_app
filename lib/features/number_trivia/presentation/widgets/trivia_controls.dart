import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final TextEditingController searchControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a Number'),
          controller: searchControl,
          onSubmitted: (_) => addConcrete(),
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 45.0,
                child: ElevatedButton(
                  onPressed: addConcrete,
                  child: const Text('Search'),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: SizedBox(
                height: 45.0,
                child: ElevatedButton(
                  onPressed: addRandom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Get Random Trivia'),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void addConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForConcreteNumber(searchControl.text),
    );
    searchControl.clear();
  }

  void addRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}

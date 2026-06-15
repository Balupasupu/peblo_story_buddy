import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_model.dart';
import '../providers/quiz_provider.dart';

class QuizCard extends ConsumerStatefulWidget {
  final QuizModel quiz;

  const QuizCard({
    super.key,
    required this.quiz,
  });

  @override
  ConsumerState<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends ConsumerState<QuizCard> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizProvider);

    if (state.showSuccess) {
      _confettiController.play();
    }

    Widget card = Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.quiz.question,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ...widget.quiz.options.map(
              (option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          state.showSuccess &&
                                  option == widget.quiz.answer
                              ? Colors.green
                              : null,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      ref
                          .read(quizProvider.notifier)
                          .checkAnswer(
                            option,
                            widget.quiz.answer,
                          );
                    },
                    child: Text(option),
                  ),
                ),
              ),
            ),

            if (state.showSuccess)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "🎉 Great Job!\nYou helped Pip find his blue gear!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (state.shake) {
      card = ShakeX(child: card);
    }

    return Column(
      children: [
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
        ),
        card,
      ],
    );
  }
}
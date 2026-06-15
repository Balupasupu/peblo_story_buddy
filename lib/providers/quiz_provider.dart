import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizState {
  final bool isCorrect;
  final bool showSuccess;
  final bool shake;

  QuizState({
    this.isCorrect = false,
    this.showSuccess = false,
    this.shake = false,
  });

  QuizState copyWith({
    bool? isCorrect,
    bool? showSuccess,
    bool? shake,
  }) {
    return QuizState(
      isCorrect: isCorrect ?? this.isCorrect,
      showSuccess: showSuccess ?? this.showSuccess,
      shake: shake ?? this.shake,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(QuizState());

  void checkAnswer(String selected, String answer) {
    if (selected == answer) {
      state = state.copyWith(
        isCorrect: true,
        showSuccess: true,
        shake: false,
      );
    } else {
      // Haptic Feedback
      HapticFeedback.mediumImpact();

      state = state.copyWith(
        shake: true,
      );

      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          state = state.copyWith(
            shake: false,
          );
        },
      );
    }
  }
}

final quizProvider =
    StateNotifierProvider<QuizNotifier, QuizState>(
  (ref) => QuizNotifier(),
);
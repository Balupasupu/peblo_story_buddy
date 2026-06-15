import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/tts_provider.dart';
import '../data/quiz_data.dart';
import '../models/quiz_model.dart';
import '../widgets/quiz_card.dart';
import '../providers/quiz_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const storyText =
      "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(ttsProvider);
    final quiz = QuizModel.fromJson(quizJson);
    final quizState = ref.watch(quizProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("🤖 Peblo Story Buddy"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              CircleAvatar(
  radius: 70,
  backgroundColor: Colors.white,
  child: Icon(
    quizState.showSuccess
        ? Icons.sentiment_very_satisfied
        : Icons.smart_toy,
    size: 80,
    color: quizState.showSuccess
        ? Colors.orange
        : Colors.deepPurple,
  ),
),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  ref
                      .read(ttsProvider.notifier)
                      .speakStory(storyText);
                },
                child: const Text(
                  "📖 Read Me A Story",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    storyText,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (audioState == AudioState.loading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),

              if (audioState == AudioState.completed) ...[
                const SizedBox(height: 20),
                QuizCard(quiz: quiz),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
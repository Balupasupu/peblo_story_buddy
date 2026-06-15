import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum AudioState {
  idle,
  loading,
  playing,
  completed,
  error,
}

class TtsNotifier extends StateNotifier<AudioState> {
  TtsNotifier() : super(AudioState.idle) {
    _init();
  }

  final FlutterTts _tts = FlutterTts();

  void _init() {
    _tts.setStartHandler(() {
      state = AudioState.playing;
    });

    _tts.setCompletionHandler(() {
      state = AudioState.completed;
    });

    _tts.setErrorHandler((msg) {
      state = AudioState.error;
    });
  }

  Future<void> speakStory(String story) async {
    try {
      state = AudioState.loading;

      await _tts.setLanguage("en-US");
      await _tts.setPitch(1.0);
      await _tts.speak(story);
    } catch (e) {
      state = AudioState.error;
    }
  }
}

final ttsProvider =
    StateNotifierProvider<TtsNotifier, AudioState>(
  (ref) => TtsNotifier(),
);
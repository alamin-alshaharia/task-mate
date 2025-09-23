import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../utils/logger.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _speechEnabled = false;
  String _lastWords = '';

  // Initialize speech services
  Future<bool> initialize() async {
    try {
      // Check if speech recognition is available on this device
      bool available = await _speechToText.hasPermission;
      if (!available) {
        AppLogger.w(
            'Speech recognition permission not available on this device');
        // Still continue with initialization attempt
      }

      // Request microphone permission
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        AppLogger.w('Microphone permission denied');
        return false;
      }

      // Initialize speech to text
      _speechEnabled = await _speechToText.initialize(
        onError: (error) => AppLogger.e('Speech recognition error: $error'),
        onStatus: (status) => AppLogger.d('Speech recognition status: $status'),
      );

      // Initialize text to speech
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      AppLogger.d('Speech service initialized: $_speechEnabled');
      return _speechEnabled;
    } catch (e) {
      AppLogger.e('Error initializing speech service: $e');
      return false;
    }
  }

  // Check if speech recognition is available
  bool get isAvailable => _speechEnabled;

  // Check if currently listening
  bool get isListening => _speechToText.isListening;

  // Get last recognized words
  String get lastWords => _lastWords;

  // Start listening for speech
  Future<void> startListening({
    required Function(String) onResult,
    Function(String)? onError,
  }) async {
    if (!_speechEnabled) {
      await initialize();
    }

    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          onResult(_lastWords);
          AppLogger.d('Speech result: $_lastWords');
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: "en_US",
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
    } else {
      onError?.call('Speech recognition not available');
    }
  }

  // Stop listening
  Future<void> stopListening() async {
    await _speechToText.stop();
    AppLogger.d('Speech recognition stopped');
  }

  // Cancel listening
  Future<void> cancelListening() async {
    await _speechToText.cancel();
    AppLogger.d('Speech recognition cancelled');
  }

  // Speak text (voice feedback)
  Future<void> speak(String text) async {
    try {
      await _flutterTts.speak(text);
      AppLogger.d('Speaking: $text');
    } catch (e) {
      AppLogger.e('Error speaking text: $e');
    }
  }

  // Stop speaking
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  // Parse speech input to extract task details
  TaskSpeechData parseTaskFromSpeech(String speechText) {
    String title = '';
    String description = '';
    DateTime? dueDate;
    String priority = 'medium';

    // Convert to lowercase for easier parsing
    String text = speechText.toLowerCase().trim();

    // Extract title (everything before "description" or "details")
    if (text.contains('description') || text.contains('details')) {
      int descIndex = text.contains('description')
          ? text.indexOf('description')
          : text.indexOf('details');
      title = text.substring(0, descIndex).trim();
      description = text.substring(descIndex).trim();

      // Remove description/details keywords
      description = description
          .replaceFirst('description', '')
          .replaceFirst('details', '')
          .trim();
    } else {
      title = text;
    }

    // Extract priority
    if (text.contains('high priority') ||
        text.contains('urgent') ||
        text.contains('important')) {
      priority = 'high';
    } else if (text.contains('low priority') || text.contains('later')) {
      priority = 'low';
    }

    // Extract due date (basic patterns)
    if (text.contains('today')) {
      dueDate = DateTime.now();
    } else if (text.contains('tomorrow')) {
      dueDate = DateTime.now().add(const Duration(days: 1));
    } else if (text.contains('next week')) {
      dueDate = DateTime.now().add(const Duration(days: 7));
    }

    // Clean up title
    title = _cleanTitle(title);

    return TaskSpeechData(
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
    );
  }

  // Clean up the title by removing common speech artifacts
  String _cleanTitle(String title) {
    // Remove common speech-to-text artifacts and keywords
    List<String> wordsToRemove = [
      'create task',
      'add task',
      'new task',
      'make task',
      'create a task',
      'add a task',
      'make a task',
      'task',
      'called',
      'named',
      'titled',
      'priority',
      'high',
      'low',
      'medium',
      'today',
      'tomorrow',
      'next week',
    ];

    String cleaned = title;
    for (String word in wordsToRemove) {
      cleaned = cleaned.replaceAll(word, '');
    }

    // Clean up extra spaces and capitalize
    cleaned = cleaned.trim();
    if (cleaned.isNotEmpty) {
      cleaned = cleaned[0].toUpperCase() + cleaned.substring(1);
    }

    return cleaned.isEmpty ? 'Voice Task' : cleaned;
  }
}

// Data class for parsed speech
class TaskSpeechData {
  final String title;
  final String description;
  final DateTime? dueDate;
  final String priority;

  TaskSpeechData({
    required this.title,
    required this.description,
    this.dueDate,
    required this.priority,
  });
}

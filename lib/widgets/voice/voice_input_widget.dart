import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/speech_service.dart';
import '../../utils/logger.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(TaskSpeechData) onSpeechResult;
  final VoidCallback? onCancel;
  final Function(String)? onError;

  const VoiceInputWidget({
    super.key,
    required this.onSpeechResult,
    this.onCancel,
    this.onError,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  final SpeechService _speechService = SpeechService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isListening = false;
  bool _isInitialized = false;
  String _recognizedText = '';
  String _status = 'Tap to start listening';

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _initializeSpeech();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  Future<void> _initializeSpeech() async {
    try {
      bool initialized = await _speechService.initialize();
      setState(() {
        _isInitialized = initialized;
        _status = initialized
            ? 'Tap to start listening'
            : 'Speech recognition not available on this device';
      });
    } catch (e) {
      AppLogger.e('Error initializing speech: $e');
      setState(() {
        _isInitialized = false;
        _status = 'Speech recognition not available on this device';
      });
    }
  }

  Future<void> _startListening() async {
    if (!_isInitialized) {
      await _initializeSpeech();
      if (!_isInitialized) {
        // Show snackbar or toast informing user
        if (widget.onError != null) {
          widget.onError!('Speech recognition is not available on this device');
        }
        return;
      }
    }

    setState(() {
      _isListening = true;
      _recognizedText = '';
      _status = 'Listening... Say your task';
    });

    // Only try to speak if speech is available
    if (_speechService.isAvailable) {
      try {
        await _speechService.speak('I\'m listening. Tell me your task.');
      } catch (e) {
        AppLogger.e('Error with text-to-speech: $e');
      }
    }

    await _speechService.startListening(
      onResult: (result) {
        setState(() {
          _recognizedText = result;
          _status = 'Recognized: $result';
        });
      },
      onError: (error) {
        setState(() {
          _isListening = false;
          _status = 'Error: $error';
        });
        _animationController.stop();
      },
    );

    // Auto-stop after 30 seconds or when speech ends
    Future.delayed(const Duration(seconds: 30), () {
      if (_isListening) {
        _stopListening();
      }
    });
  }

  Future<void> _stopListening() async {
    await _speechService.stopListening();
    setState(() {
      _isListening = false;
    });
    _animationController.stop();

    if (_recognizedText.isNotEmpty) {
      // Parse the speech and return result
      TaskSpeechData taskData =
          _speechService.parseTaskFromSpeech(_recognizedText);
      await _speechService
          .speak('Task "${taskData.title}" created successfully');
      widget.onSpeechResult(taskData);
    } else {
      setState(() {
        _status = 'No speech detected. Try again.';
      });
    }
  }

  Future<void> _cancelListening() async {
    await _speechService.cancelListening();
    setState(() {
      _isListening = false;
      _recognizedText = '';
      _status = 'Cancelled';
    });
    _animationController.stop();
    widget.onCancel?.call();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Voice Task Creation',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              IconButton(
                onPressed: _cancelListening,
                icon: const Icon(Icons.close),
                color: Colors.grey[600],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Microphone Button
          GestureDetector(
            onTap: _isListening ? _stopListening : _startListening,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isListening ? _scaleAnimation.value : 1.0,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _isListening
                            ? [Colors.red[400]!, Colors.red[600]!]
                            : [Colors.blue[400]!, Colors.blue[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? Colors.red : Colors.blue)
                              .withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Status Text
          Text(
            _status,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          if (_recognizedText.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recognized Text:',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _recognizedText,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _cancelListening,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[700],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (_recognizedText.isNotEmpty) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      TaskSpeechData taskData =
                          _speechService.parseTaskFromSpeech(_recognizedText);
                      widget.onSpeechResult(taskData);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Create Task',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // Help Text
          Text(
            'Try saying: "Create task buy groceries tomorrow high priority"',
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

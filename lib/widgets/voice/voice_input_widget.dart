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
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _isListening = false;
  bool _isInitialized = false;
  bool _isInitializing = false;

  /// True when the user tapped the mic while initialization was still in
  /// progress. We'll auto-start listening once init finishes.
  bool _pendingListen = false;

  /// Guard against double-taps / re-entrant calls to _useText.
  bool _isSubmitting = false;

  String _recognizedText = '';
  String _status = 'Tap the mic to start';

  // Allow the user to manually edit the recognized text
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _initializeAnimation();
    _initializeSpeech();
  }

  void _initializeAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeSpeech() async {
    if (_isInitializing) return;

    if (mounted) {
      setState(() {
        _isInitializing = true;
        _status = 'Initializing microphone…';
      });
    }

    try {
      final bool initialized = await _speechService.initialize();
      if (!mounted) return;

      setState(() {
        _isInitialized = initialized;
        _isInitializing = false;
        _status = initialized
            ? 'Tap the mic to start'
            : 'Microphone not available. Please grant permission.';
      });

      // If the user already tapped the mic while we were initialising, start now.
      if (initialized && _pendingListen) {
        _pendingListen = false;
        _startListening();
      }
    } catch (e) {
      AppLogger.e('Error initializing speech: $e');
      if (!mounted) return;
      setState(() {
        _isInitialized = false;
        _isInitializing = false;
        _pendingListen = false;
        _status = 'Could not initialize microphone.';
      });
    }
  }

  Future<void> _startListening() async {
    // If still initializing, remember the intent and let _initializeSpeech
    // kick it off when ready — never silently drop the tap.
    if (_isInitializing) {
      setState(() {
        _pendingListen = true;
        _status = 'Initializing… will start automatically';
      });
      return;
    }

    if (!_isInitialized) {
      await _initializeSpeech();
      // _initializeSpeech will auto-call _startListening via _pendingListen
      // if it succeeds, so we return here.
      return;
    }

    if (_isListening) return; // already listening

    setState(() {
      _isListening = true;
      _recognizedText = '';
      _textEditingController.text = '';
      _status = 'Listening… speak your task now';
    });
    _pulseController.repeat(reverse: true);

    await _speechService.startListening(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _recognizedText = result;
            _textEditingController.text = result;
            _status = 'Tap stop when done';
          });
        }
      },
      onError: (error) {
        AppLogger.e('Speech error: $error');
        if (mounted) {
          setState(() {
            _isListening = false;
            _status = 'Recognition error — tap mic to try again.';
          });
          _pulseController.stop();
          _pulseController.reset();
        }
      },
      onDone: () {
        if (mounted && _isListening) {
          setState(() {
            _isListening = false;
            _status = _recognizedText.isEmpty
                ? 'No speech detected. Tap mic to try again.'
                : 'Review text below, then tap "Use This Text"';
          });
          _pulseController.stop();
          _pulseController.reset();
        }
      },
    );
  }

  Future<void> _stopListening() async {
    if (!_isListening) return;
    // Update UI immediately so the button doesn't feel frozen
    setState(() {
      _isListening = false;
      _status = 'Stopping…';
    });
    _pulseController.stop();
    _pulseController.reset();

    await _speechService.stopListening();

    if (mounted) {
      setState(() {
        _status = _recognizedText.isEmpty
            ? 'No speech detected. Tap mic to try again.'
            : 'Review text below, then tap "Use This Text"';
      });
    }
  }

  Future<void> _cancelListening() async {
    _pulseController.stop();
    _pulseController.reset();
    if (_isListening) {
      await _speechService.cancelListening();
    }
    if (mounted) {
      setState(() {
        _isListening = false;
        _pendingListen = false;
        _recognizedText = '';
        _textEditingController.text = '';
        _status = 'Cancelled';
      });
    }
    widget.onCancel?.call();
  }

  /// Stop the speech engine first, THEN pass data up — prevents the
  /// engine's cleanup from racing with page navigation (ANR root cause).
  Future<void> _useText() async {
    if (_isSubmitting) return;
    final text = _textEditingController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true);

    // 1. Gracefully stop the speech engine before we hand off control.
    if (_isListening) {
      _pulseController.stop();
      _pulseController.reset();
      await _speechService.stopListening();
      if (mounted) setState(() => _isListening = false);
    }

    // 2. Parse result (pure Dart, never blocks).
    final taskData = _speechService.parseTaskFromSpeech(text);

    // 3. Only now navigate — the speech engine is fully idle.
    widget.onSpeechResult(taskData);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textEditingController.dispose();
    // Fire-and-forget cancel — dispose must be synchronous.
    // The engine is already stopped by _useText / _cancelListening in the
    // normal flow; this is just a safety net for unexpected closes.
    _speechService.cancelListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = _textEditingController.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Voice Task Input',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[850],
                ),
              ),
              IconButton(
                onPressed: _isSubmitting ? null : _cancelListening,
                icon: const Icon(Icons.close),
                color: Colors.grey[600],
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Microphone Button with pulse
          GestureDetector(
            onTap: _isSubmitting
                ? null
                : (_isListening ? _stopListening : _startListening),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isListening ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _isListening
                            ? [Colors.red[400]!, Colors.red[700]!]
                            : (_isInitializing || _pendingListen)
                                ? [Colors.grey[400]!, Colors.grey[600]!]
                                : [Colors.blue[400]!, Colors.blue[700]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? Colors.red : Colors.blue)
                              .withValues(alpha: 0.35),
                          blurRadius: 18,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: (_isInitializing || _pendingListen)
                        ? const Padding(
                            padding: EdgeInsets.all(28),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Icon(
                            _isListening ? Icons.stop_rounded : Icons.mic,
                            size: 44,
                            color: Colors.white,
                          ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Status text
          Text(
            _status,
            style: GoogleFonts.lato(
              fontSize: 13,
              color: _isListening ? Colors.red[600] : Colors.grey[600],
              fontWeight:
                  _isListening ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Editable recognized text area
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasText ? Colors.blue[200]! : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _textEditingController,
              maxLines: 3,
              minLines: 3,
              enabled: !_isSubmitting,
              onChanged: (value) {
                setState(() => _recognizedText = value);
              },
              decoration: InputDecoration(
                hintText:
                    'Your spoken text will appear here.\nYou can also type or edit it.',
                hintStyle: GoogleFonts.lato(
                  fontSize: 13,
                  color: Colors.grey[400],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14),
              ),
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey[850],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Hint
          Text(
            'Tip: Say "buy groceries tomorrow high priority"',
            style: GoogleFonts.lato(
              fontSize: 11,
              color: Colors.grey[400],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSubmitting ? null : _cancelListening,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: (hasText && !_isSubmitting) ? _useText : null,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: Text(
                    _isSubmitting ? 'Processing…' : 'Use This Text',
                    style: GoogleFonts.lato(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[200],
                    disabledForegroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

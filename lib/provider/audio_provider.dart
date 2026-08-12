import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

// Enum to keep track of what the audio player is currently playing
enum PlayerMode { allahNames, none }

/// A provider class that manages the audio playback state using the just_audio package.
/// It implements WidgetsBindingObserver to react to application lifecycle changes.
class AudioProvider extends ChangeNotifier with WidgetsBindingObserver {
  // Main audio player instance from just_audio
  final AudioPlayer _player = AudioPlayer();
  
  PlayerMode _mode = PlayerMode.none;
  bool _isLoading = false;
  String? _errorMessage;

  // Public getters for the UI to access the state
  AudioPlayer get player => _player;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAllahNamesPlaying => _mode == PlayerMode.allahNames;
  PlayerMode get mode => _mode;

  StreamSubscription? _playerStateSubscription;

  AudioProvider() {
    WidgetsBinding.instance.addObserver(this);

    // Listen to player state changes (playing, paused, completed, etc.)
    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Automatically reset mode when audio reaches the end
        if (_mode == PlayerMode.allahNames) {
          _mode = PlayerMode.none;
        }
      }
      // Notify UI to rebuild on state change
      notifyListeners();
    });
  }

  @override
  void dispose() {
    // Clean up resources when the provider is destroyed
    WidgetsBinding.instance.removeObserver(this);
    _playerStateSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  /// Sets up and starts playback for the Allah Names audio.
  /// [startSeconds] allows seeking to a specific time (e.g., skip intro).
  Future<void> playAllahNames(BuildContext context, {double startSeconds = 0}) async {
    try {
      await _player.stop();

      _isLoading = true;
      _errorMessage = null;
      _mode = PlayerMode.allahNames;
      notifyListeners();

      // Load the audio asset and set metadata for background controls
      await _player.setAudioSource(
        AudioSource.asset(
          'assets/audio/names.mp3',
          tag: MediaItem(
            id: 'allah_names_audio',
            album: "Islam Plus",
            title: "Asma-ul-husna",
            // Artist, artUri, etc., can be added here for a richer notification experience
          ),
        ),
      );

      _isLoading = false;
      notifyListeners();

      // Seek if a start time is provided
      if (startSeconds > 0) {
        await _player.seek(Duration(milliseconds: (startSeconds * 1000).toInt()));
      }
      
      // Begin playback
      await _player.play();
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Error playing audio";
      notifyListeners();
      debugPrint("Audio Playback Error: $e");
    }
  }

  /// Toggles between play and pause states
  Future<void> togglePlayback() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
    notifyListeners();
  }

  /// Stops audio playback and resets the mode
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      debugPrint('Error stopping player: $e');
    }
    _mode = PlayerMode.none;
    notifyListeners();
  }
}

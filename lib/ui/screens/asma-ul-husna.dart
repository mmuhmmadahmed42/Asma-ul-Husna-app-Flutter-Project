import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/audio_provider.dart';
import '../../model/asma-ul-husna.dart';

// The primary accent color used throughout the screen for highlights and buttons
const Color accentColor = Color(0xFF18D2D1);

class AllahNames extends StatefulWidget {
  const AllahNames({super.key});

  @override
  State<AllahNames> createState() => _AllahNamesState();
}

class _AllahNamesState extends State<AllahNames> {
  List<AllahName> _names = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load the data from JSON when the screen initializes
    _loadNames();
  }

  /// Reads the local JSON file containing the 99 Names of Allah,
  /// parses it into a list of AllahName objects, and updates the UI state.
  Future<void> _loadNames() async {
    try {
      final String response = await rootBundle.loadString('assets/json/asma-ul-husna.json');
      final data = await json.decode(response);
      setState(() {
        _names = (data as List).map((i) => AllahName.fromJson(i)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading Allah names: $e");
      setState(() => _isLoading = false);
    }
  }

  /// Handles screen taps to control audio playback.
  /// If audio isn't playing, it starts from a preset intro point (5.6s).
  /// If already playing, it skips to the next name's audio start time.
  void _onScreenTapped(AudioProvider provider) {
    if (_names.isEmpty) return;

    if (provider.mode != PlayerMode.allahNames) {
      // Start initial playback
      provider.playAllahNames(context, startSeconds: 5.6);
      return;
    }

    // Seek to the next name based on current index
    int nextIndex = (_currentIndex + 1) % _names.length;
    provider.player.seek(Duration(milliseconds: (_names[nextIndex].startTime * 1000).toInt()));
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the AudioProvider to respond to audio state changes
    final audioProvider = context.watch<AudioProvider>();

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF042A29),
        body: Center(child: CircularProgressIndicator(color: accentColor)),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: StreamBuilder<Duration>(
        // Listen to the current position of the audio player
        stream: audioProvider.player.positionStream,
        builder: (context, snapshot) {
          final position = snapshot.data ?? Duration.zero;

          // Sync the current displayed name with the audio playback position
          if (audioProvider.mode == PlayerMode.allahNames) {
            double currentSecs = position.inMilliseconds / 1000.0;
            int foundIndex = 0;
            for (int i = 0; i < _names.length; i++) {
              if (_names[i].startTime <= currentSecs) {
                foundIndex = i;
              } else {
                break;
              }
            }
            if (_currentIndex != foundIndex) {
              _currentIndex = foundIndex;
            }
          }

          final currentName = _names.isNotEmpty ? _names[_currentIndex] : null;
          final double firstNameStart = _names.isNotEmpty ? _names[0].startTime : 5.6;
          // Check if we are currently playing the introductory part of the audio
          final bool isIntro = position.inSeconds < firstNameStart && audioProvider.mode == PlayerMode.allahNames;

          return GestureDetector(
            onTap: () => _onScreenTapped(audioProvider),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF063B3A), Color(0xFF042A29), Color(0xFF021A19)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    // Animated switcher for smooth transitions between names and intro text
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: isIntro
                          ? Column(
                              key: const ValueKey('intro'),
                              children: [
                                Text(
                                  "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ",
                                  style: GoogleFonts.amiri(
                                    fontSize: 32,
                                    color: accentColor.withValues(alpha: 0.8),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Text(
                                  "اللہ",
                                  style: GoogleFonts.amiri(
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "ALLAH",
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: accentColor,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ],
                            )
                          : currentName != null
                              ? Column(
                                  key: ValueKey<int>(currentName.id),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 44),
                                    Text(
                                      currentName.arabic,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.amiri(
                                        fontSize: 84,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      currentName.transliteration.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: accentColor,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 40),
                                      child: Text(
                                        currentName.urduMeaning,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.notoNastaliqUrdu(
                                          fontSize: 22,
                                          color: Colors.white70,
                                          height: 2.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                    ),
                    const Spacer(flex: 3),
                    // UI components for audio progress and player controls
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: _buildSlider(audioProvider),
                    ),
                    const SizedBox(height: 10),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: _buildControls(audioProvider),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "TAP SCREEN FOR NEXT NAME",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white24,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the audio progress slider
  Widget _buildSlider(AudioProvider audioProvider) {
    return StreamBuilder<Duration>(
      stream: audioProvider.player.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = audioProvider.player.duration ?? Duration.zero;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                  activeTrackColor: accentColor,
                  inactiveTrackColor: Colors.white12,
                  thumbColor: accentColor,
                ),
                child: Slider(
                  min: 0,
                  max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
                  value: position.inMilliseconds.toDouble().clamp(
                      0.0, duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 0.0),
                  onChanged: (value) {
                    audioProvider.player.seek(Duration(milliseconds: value.toInt()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(position),
                      style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
                    ),
                    Text(
                      _formatDuration(duration),
                      style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Formats duration into MM:SS string
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  /// Builds playback control buttons (Reset, Previous, Play/Pause, Next)
  Widget _buildControls(AudioProvider audioProvider) {
    final isPlaying = audioProvider.isAllahNamesPlaying && audioProvider.player.playing;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            // Replay from the beginning of names
            audioProvider.player.seek(const Duration(milliseconds: 5600));
          },
          tooltip: 'Reset',
          icon: const Icon(Icons.replay_rounded, size: 28, color: Colors.white60),
        ),
        const SizedBox(width: 15),
        IconButton(
          onPressed: () {
            if (_currentIndex > 0) {
              int prevIndex = _currentIndex - 1;
              audioProvider.player.seek(Duration(milliseconds: (_names[prevIndex].startTime * 1000).toInt()));
            }
          },
          icon: const Icon(Icons.skip_previous_rounded, size: 40, color: Colors.white70),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            if (audioProvider.isAllahNamesPlaying) {
              audioProvider.togglePlayback();
            } else {
              audioProvider.playAllahNames(context, startSeconds: 5.6);
            }
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor,
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 40,
              color: const Color(0xFF042A29),
            ),
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: () {
            if (_currentIndex < _names.length - 1) {
              int nextIndex = _currentIndex + 1;
              audioProvider.player.seek(Duration(milliseconds: (_names[nextIndex].startTime * 1000).toInt()));
            }
          },
          icon: const Icon(Icons.skip_next_rounded, size: 40, color: Colors.white70),
        ),
        const SizedBox(width: 15),
        const SizedBox(width: 48),
      ],
    );
  }
}

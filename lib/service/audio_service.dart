import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/asset_audios.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MusicType { home, adventure, challenge }

class AudioService {
  AudioService._internal();

  static final AudioService instance = AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _soundTrackPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();

  bool _isSoundOn = true;
  bool _isMusicOn = true;

  final Map<String, AudioPlayer> _sounds = {};

  MusicType? _currentMusic;

  bool get isSoundOn => _isSoundOn;
  bool get isMusicOn => _isMusicOn;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundOn = prefs.getBool(CcConstants.IS_SOUND_ON) ?? true;
    _isMusicOn = prefs.getBool(CcConstants.IS_MUSIC_ON) ?? true;

    final assets = {
      'tap': AssetAudios.tapSound,
      'back': AssetAudios.backSound,
      'correct': AssetAudios.correctSound,
      'wrong': AssetAudios.wrongSound,
      'adv-win': AssetAudios.adventureWinSound,
      'ch-win': AssetAudios.challengeWinSound,
      'adv-lose': AssetAudios.adventureLoseSound,
      'ch-lose': AssetAudios.challengeLoseSound,
      'claim': AssetAudios.claimSound,
    };

    for (var entry in assets.entries) {
      final player = AudioPlayer();
      await player.setAudioSource(AudioSource.asset(entry.value));
      _sounds[entry.key] = player;
    }

    if (_isMusicOn) {
      await playMusic(MusicType.home);
    }
  }

  Future<void> setSound(bool isOn) async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundOn = isOn;
    await prefs.setBool(CcConstants.IS_SOUND_ON, isSoundOn);

  }

  Future<void> setMusic(bool isOn) async {
    final prefs = await SharedPreferences.getInstance();
    _isMusicOn = isOn;
    await prefs.setBool(CcConstants.IS_MUSIC_ON, isMusicOn);

    if (isOn) {
      await playBackMusic();
    } else {
      await stopMusic();
    }
  }

  Future<void> playMusic(MusicType type) async {
    if (!_isMusicOn || _currentMusic == type) return;

    _currentMusic = type;

    final asset = switch (type) {
      MusicType.home => AssetAudios.flaguizThemeSound,
      MusicType.adventure => AssetAudios.adventureThemeSound,
      MusicType.challenge => AssetAudios.challengeThemeSound,
    };
    try {
      await _musicPlayer.stop();
      await _musicPlayer.setLoopMode(LoopMode.one);
      await _musicPlayer.setAsset(asset);
      await _musicPlayer.play();
    } catch (e, s) {
      debugPrint("Music playback error: $e");
      debugPrint("$s");
    }
  }

  Future<void> playBackMusic() async {
    if (!_isMusicOn) return;
    try {
      await _musicPlayer.stop();
      await _musicPlayer.setLoopMode(LoopMode.one);
      await _musicPlayer.setAsset(AssetAudios.flaguizThemeSound);
      await _musicPlayer.play();
    } catch (e, s) {
      debugPrint("Music playback error: $e");
      debugPrint("$s");
    }
  }

  Future<void> pause() async {
    if (_musicPlayer.playing) {
      await _musicPlayer.pause();
    }
  }

  Future<void> resume() async {
    if (_isMusicOn && !_musicPlayer.playing && _currentMusic != null) {
      await _musicPlayer.play();
    }
  }

  Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }

  // Future<void> startSound(String assetPath) async {
  //   if (!_isSoundOn) return;
  //   _audioPlayer.stop();
  //   await _audioPlayer.setAudioSource(AudioSource.asset(assetPath));
  //   await _audioPlayer.seek(Duration.zero);
  //   await _audioPlayer.play();
  // }

  // Future<void> stopSound() async {
  //   await _audioPlayer.stop();
  // }

    Future<void> playSound(String key) async {
    if (!_isSoundOn) return;
    final player = _sounds[key];
    if (player == null) return;

    await player.seek(Duration.zero);
    player.play();
  }

  Future<void> startSoundTrack(String assetPath) async {
    if (!_isSoundOn) return;
    _soundTrackPlayer.stop();
    await _soundTrackPlayer.setAudioSource(AudioSource.asset(assetPath),
        preload: false);
    await _soundTrackPlayer.seek(Duration.zero);
    await _soundTrackPlayer.play();
  }

  Future<void> stopSoundTrack() async {
    await _soundTrackPlayer.stop();
  }

  void dispose() {
    _musicPlayer.dispose();
    _audioPlayer.dispose();
    _soundTrackPlayer.dispose();
  }
}

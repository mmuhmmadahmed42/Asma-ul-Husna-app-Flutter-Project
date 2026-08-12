import 'package:flutter/material.dart';

class AllahName {
  final int id;
  final String arabic;
  final String transliteration;
  final String urduMeaning;
  final double startTime;

  AllahName({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.urduMeaning,
    required this.startTime,
  });

  factory AllahName.fromJson(Map<String, dynamic> json) {
    return AllahName(
      id: json['id'],
      arabic: json['arabic'],
      transliteration: json['transliteration'],
      urduMeaning: json['urduMeaning'] ?? '',
      startTime: json['startTime'].toDouble(),
    );
  }

  String getLocalizedMeaning(BuildContext context) {
    return urduMeaning;
  }
}

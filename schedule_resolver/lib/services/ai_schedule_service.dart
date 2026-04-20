import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/task_model.dart';
import '../models/schedule_analysis.dart';

class AiScheduleAnalysis extends ChangeNotifier {
  ScheduleAnalysis? _currentAnalysis;
  bool _isLoading = false;
  String? _errorMessage;

  final String _apiKey = 'input api key';

  ScheduleAnalysis? get currentAnalysis => _currentAnalysis;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> analyzeSchedule(List<TaskModel> tasks) async {
    if (_apiKey.isEmpty || tasks.isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
      );

      final taskJson = jsonEncode(tasks.map((t) => t.toJson()).toList());

      final prompt = '''
You are an expert student scheduling assistant.

The user has provided the following tasks in JSON:
$taskJson

IMPORTANT RULES:
- Do NOT use markdown bold (**)
- Do NOT use asterisks (*)
- Use plain text only
- Use hyphens (-) for bullet points

Provide EXACTLY these 4 sections:

### Detected Conflicts
List any scheduling conflicts.

### Ranked Tasks
Rank which tasks need attention first.

### Recommended Schedule
Provide a revised daily timeline.

### Explanation
Explain why this recommendation was made.
''';

      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        _currentAnalysis = _parseResponse(response.text!);
      } else {
        _errorMessage = "AI returned an empty response";
      }
    } catch (e) {
      _errorMessage = 'Failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ScheduleAnalysis _parseResponse(String fullText) {
    String conflicts = "";
    String rankedTasks = "";
    String recommendationSchedule = "";
    String explanation = "";

    final sections = fullText.split('### ');

    for (var section in sections) {
      if (section.isEmpty) continue;

      if (section.startsWith('Detected Conflicts')) {
        conflicts = section.replaceFirst('Detected Conflicts', '').trim();
      } else if (section.startsWith('Ranked Tasks')) {
        rankedTasks = section.replaceFirst('Ranked Tasks', '').trim();
      } else if (section.startsWith('Recommended Schedule')) {
        recommendationSchedule =
            section.replaceFirst('Recommended Schedule', '').trim();
      } else if (section.startsWith('Explanation')) {
        explanation = section.replaceFirst('Explanation', '').trim();
      }
    }

    return ScheduleAnalysis(
      conflicts: _cleanMarkdown(conflicts),
      rankedTasks: _cleanMarkdown(rankedTasks),
      recommendedSchedule: _cleanMarkdown(recommendationSchedule),
      explanation: _cleanMarkdown(explanation),
    );
  }

  /// Removes unwanted markdown symbols like ** or _
  String _cleanMarkdown(String text) {
    return text
        .replaceAll('**', '')
        .replaceAll('_', '')
        .trim();
  }
}
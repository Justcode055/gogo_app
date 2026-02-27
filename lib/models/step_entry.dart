import 'dart:convert';

class StepEntry {
  final String date; // Format: yyyy-MM-dd
  final int steps;

  StepEntry({required this.date, required this.steps});

  Map<String, dynamic> toJson() => {'date': date, 'steps': steps};

  factory StepEntry.fromJson(Map<String, dynamic> json) =>
      StepEntry(date: json['date'] as String, steps: json['steps'] as int);

  static List<StepEntry> listFromJsonString(String jsonStr) {
    final List<dynamic> decoded = jsonDecode(jsonStr) as List<dynamic>;
    return decoded
        .map((e) => StepEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJsonString(List<StepEntry> entries) =>
      jsonEncode(entries.map((e) => e.toJson()).toList());

  /// Human-readable label for the history list
  String get displayDate {
    final today = _dateOnly(DateTime.now());
    final yesterday = _dateOnly(DateTime.now().subtract(const Duration(days: 1)));
    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';
    final parts = date.split('-');
    final dt = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}';
  }

  static String _dateOnly(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

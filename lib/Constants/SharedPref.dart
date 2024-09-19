import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  static const String TASKS_KEY = 'tasks';

  // Save tasks to SharedPreferences
  static Future<void> saveTasks(Map<String, List<String>> tasksByDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> tasksJson = tasksByDate.map((key, value) => MapEntry(key, jsonEncode(value)));
    prefs.setString(TASKS_KEY, jsonEncode(tasksJson));
  }

  // Load tasks from SharedPreferences
  static Future<Map<String, List<String>>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString(TASKS_KEY);

    if (tasksString != null) {
      Map<String, dynamic> decodedTasks = jsonDecode(tasksString);
      return decodedTasks.map((key, value) => MapEntry(key, List<String>.from(jsonDecode(value))));
    }

    return {};
  }
}

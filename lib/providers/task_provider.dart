import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:taskmate/models/task.dart';
import 'package:taskmate/services/api_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks({int? boardId}) async {
    _setLoading(true);
    try {
      final Map<String, dynamic> params = {};
      if (boardId != null) {
        params['board_id'] = boardId;
      }

      final response = await apiService.dio.get(
        '/tasks',
        queryParameters: params,
      );
      final List data = response.data['data'];
      _tasks = data.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createTask(Map<String, dynamic> taskData) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.post('/tasks', data: taskData);
      _tasks.insert(0, Task.fromJson(response.data['data']));
      notifyListeners();
    } on DioException catch (e) {
      debugPrint('Error creating task: ${e.response?.data}');
      rethrow;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> taskData) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.put('/tasks/$id', data: taskData);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = Task.fromJson(response.data['data']);
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTask(int id) async {
    _setLoading(true);
    try {
      await apiService.dio.delete('/tasks/$id');
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

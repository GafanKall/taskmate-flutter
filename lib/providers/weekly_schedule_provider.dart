import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:taskmate/models/weekly_schedule.dart';
import 'package:taskmate/services/api_service.dart';

class WeeklyScheduleProvider extends ChangeNotifier {
  List<WeeklySchedule> _schedules = [];
  bool _isLoading = false;

  List<WeeklySchedule> get schedules => _schedules;
  bool get isLoading => _isLoading;

  Future<void> fetchSchedules() async {
    _setLoading(true);
    try {
      final response = await apiService.dio.get('/weekly-schedules');
      final List data = response.data['data'];
      _schedules = data.map((item) => WeeklySchedule.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createSchedule(Map<String, dynamic> scheduleData) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.post(
        '/weekly-schedules',
        data: scheduleData,
      );
      _schedules.add(WeeklySchedule.fromJson(response.data['data']));
      _schedules.sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));
      notifyListeners();
    } on DioException catch (e) {
      debugPrint('Error creating schedule: ${e.response?.data}');
      rethrow;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateSchedule(int id, Map<String, dynamic> scheduleData) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.put(
        '/weekly-schedules/$id',
        data: scheduleData,
      );
      final index = _schedules.indexWhere((s) => s.id == id);
      if (index != -1) {
        _schedules[index] = WeeklySchedule.fromJson(response.data['data']);
        _schedules.sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteSchedule(int id) async {
    _setLoading(true);
    try {
      await apiService.dio.delete('/weekly-schedules/$id');
      _schedules.removeWhere((s) => s.id == id);
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

import 'package:flutter/material.dart';
import 'package:taskmate/models/event.dart';
import 'package:taskmate/services/api_service.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> fetchEvents() async {
    _setLoading(true);
    try {
      final response = await apiService.dio.get('/events');
      final List data = response.data['data'];
      _events = data.map((item) => Event.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createEvent(Map<String, dynamic> eventData) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.post('/events', data: eventData);
      _events.add(Event.fromJson(response.data['data']));
      _events.sort((a, b) => a.startDate.compareTo(b.startDate));
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateEvent(int id, Map<String, dynamic> eventData) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.put('/events/$id', data: eventData);
      final index = _events.indexWhere((e) => e.id == id);
      if (index != -1) {
        _events[index] = Event.fromJson(response.data['data']);
        _events.sort((a, b) => a.startDate.compareTo(b.startDate));
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteEvent(int id) async {
    _setLoading(true);
    try {
      await apiService.dio.delete('/events/$id');
      _events.removeWhere((e) => e.id == id);
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

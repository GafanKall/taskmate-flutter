import 'package:flutter/material.dart';
import 'package:taskmate/models/notification.dart';
import 'package:taskmate/services/api_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    _setLoading(true);
    try {
      final response = await apiService.dio.get('/notifications');
      final List data = response.data['data'];
      _notifications = data
          .map((item) => NotificationModel.fromJson(item))
          .toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> markAllRead() async {
    try {
      await apiService.dio.post('/notifications/mark-all-read');
      await fetchNotifications();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await apiService.dio.post('/notifications/$id/mark-as-read');
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        // We could just update local state to avoid extra fetch
        await fetchNotifications();
      }
    } catch (e) {
      rethrow;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

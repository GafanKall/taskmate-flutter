import 'package:flutter/material.dart';
import 'package:taskmate/models/board.dart';
import 'package:taskmate/services/api_service.dart';

class BoardProvider extends ChangeNotifier {
  List<Board> _boards = [];
  bool _isLoading = false;

  List<Board> get boards => _boards;
  bool get isLoading => _isLoading;

  Future<void> fetchBoards() async {
    _setLoading(true);
    try {
      final response = await apiService.dio.get('/boards');
      print('API Response Boards: ${response.data}'); // Debug
      final List data = response.data['data'];
      _boards = data.map((item) => Board.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching boards: $e'); // Debug
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createBoard(String name, String? description) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.post(
        '/boards',
        data: {'name': name, 'description': description},
      );
      _boards.insert(0, Board.fromJson(response.data['data']));
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateBoard(int id, String name, String? description) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.put(
        '/boards/$id',
        data: {'name': name, 'description': description},
      );
      final index = _boards.indexWhere((b) => b.id == id);
      if (index != -1) {
        _boards[index] = Board.fromJson(response.data['data']);
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteBoard(int id) async {
    _setLoading(true);
    try {
      await apiService.dio.delete('/boards/$id');
      _boards.removeWhere((b) => b.id == id);
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

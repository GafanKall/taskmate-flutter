import 'package:flutter/material.dart';
import 'package:taskmate/models/note.dart';
import 'package:taskmate/services/api_service.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  Future<void> fetchNotes() async {
    _setLoading(true);
    try {
      final response = await apiService.dio.get('/notes');
      final List data = response.data['data'];
      _notes = data.map((item) => Note.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createNote(String title, String content, String color) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.post(
        '/notes',
        data: {'title': title, 'content': content, 'color': color},
      );
      _notes.insert(0, Note.fromJson(response.data['data']));
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateNote(
    int id,
    String title,
    String content,
    String color,
  ) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.put(
        '/notes/$id',
        data: {'title': title, 'content': content, 'color': color},
      );
      final index = _notes.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notes[index] = Note.fromJson(response.data['data']);
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteNote(int id) async {
    _setLoading(true);
    try {
      await apiService.dio.delete('/notes/$id');
      _notes.removeWhere((n) => n.id == id);
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

import 'package:flutter/material.dart';
import '../../session/domain/session_entity.dart';
import '../../../core/domain/repository.dart';
import '../../places/domain/place_entity.dart';

class StatsController extends ChangeNotifier {
  final Repository<SessionEntity> _sessionRepo;
  final Repository<PlaceEntity> _placeRepo;
  List<SessionEntity> _sessions = [];
  Map<String, double> _productivityByPlace = {};
  bool _isLoading = false;

  int _totalSessions = 0;
  double _totalHours = 0.0;
  double _averageFocus = 0.0;

  StatsController(this._sessionRepo, this._placeRepo);

  List<SessionEntity> get sessions => _sessions;
  Map<String, double> get productivityByPlace => _productivityByPlace;
  bool get isLoading => _isLoading;

  int get totalSessions => _totalSessions;
  double get totalHours => _totalHours;
  double get averageFocus => _averageFocus;

  Future<void> loadStats() async {
    _setLoading(true);
    try {
      _sessions = await _sessionRepo.getAll();
      final places = await _placeRepo.getAll();

      // Reset metrics
      _totalSessions = _sessions.length;
      _totalHours = 0.0;
      double totalFocusSum = 0.0;
      int sessionsWithFocus = 0;

      for (var session in _sessions) {
        if (session.endTime != null) {
          _totalHours += session.durationInMinutes / 60.0;
        }
        if (session.focusLevel != null) {
          totalFocusSum += session.focusLevel!;
          sessionsWithFocus++;
        }
      }

      _averageFocus = sessionsWithFocus > 0 ? totalFocusSum / sessionsWithFocus : 0.0;

      _productivityByPlace = {};
      for (var place in places) {
        final placeSessions =
            _sessions.where((s) => s.placeId == place.id).toList();

        final totalProductivity = placeSessions.fold(0.0, (sum, s) {
          return sum + s.calculateProductivity();
        });

        if (totalProductivity > 0) {
          // Normalize by number of sessions to get an average index per place, 
          // or keep as total if that's intended for ranking. 
          // Re-scaling to percentage-like 0-100 for better chart display.
          _productivityByPlace[place.name] = (totalProductivity / placeSessions.length) * 20; 
        }
      }
    } catch (e) {
      // Error handling
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

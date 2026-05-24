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

      _productivityByPlace = {};
      
      // Map active places by ID for quick lookup
      final activePlaceIds = places.map((p) => p.id).toSet();
      final activePlaceNames = places.map((p) => p.name).toSet();

      // Filter sessions to only include those from active places
      final activeSessions = _sessions.where((session) {
        // If we have placeId, check if it's in the active list
        if (session.placeId != null) {
          return activePlaceIds.contains(session.placeId);
        }
        // Fallback for older sessions or sessions with only placeName
        if (session.placeName != null) {
          return activePlaceNames.contains(session.placeName);
        }
        return false;
      }).toList();

      // Reset metrics based on active sessions only
      _totalSessions = activeSessions.length;
      _totalHours = 0.0;
      double totalFocusSum = 0.0;
      int sessionsWithFocus = 0;

      for (var session in activeSessions) {
        if (session.endTime != null) {
          _totalHours += session.durationInMinutes / 60.0;
        }
        if (session.focusLevel != null) {
          totalFocusSum += session.focusLevel!;
          sessionsWithFocus++;
        }
      }

      _averageFocus = sessionsWithFocus > 0 ? totalFocusSum / sessionsWithFocus : 0.0;

      // Group active sessions by place name
      final Map<String, List<SessionEntity>> sessionsByPlace = {};
      for (var session in activeSessions) {
        String? name = session.placeName;
        
        if (name == null && session.placeId != null) {
          try {
            name = places.firstWhere((p) => p.id == session.placeId).name;
          } catch (_) {
            continue; // Should not happen given the filter above
          }
        }
        
        if (name != null) {
          sessionsByPlace.putIfAbsent(name, () => []).add(session);
        }
      }

      sessionsByPlace.forEach((name, placeSessions) {
        final totalProductivity = placeSessions.fold(0.0, (sum, s) {
          return sum + s.calculateProductivity();
        });

        if (totalProductivity > 0) {
          _productivityByPlace[name] = (totalProductivity / placeSessions.length) * 20; 
        }
      });
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

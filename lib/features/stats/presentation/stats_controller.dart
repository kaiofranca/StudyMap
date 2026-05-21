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

  StatsController(this._sessionRepo, this._placeRepo);

  List<SessionEntity> get sessions => _sessions;
  Map<String, double> get productivityByPlace => _productivityByPlace;
  bool get isLoading => _isLoading;

  Future<void> loadStats() async {
    _setLoading(true);
    try {
      _sessions = await _sessionRepo.getAll();
      final places = await _placeRepo.getAll();
      
      _productivityByPlace = {};
      for (var place in places) {
        final placeSessions = _sessions.where((s) => s.placeId == place.id);
        final totalProductivity = placeSessions.fold(0.0, (sum, s) => sum + s.calculateProductivity());
        if (totalProductivity > 0) {
          _productivityByPlace[place.name] = totalProductivity;
        }
      }
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

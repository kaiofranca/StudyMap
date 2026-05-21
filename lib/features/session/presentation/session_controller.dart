import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../domain/session_entity.dart';
import '../../../core/domain/repository.dart';
import '../../places/domain/place_entity.dart';

class SessionController extends ChangeNotifier {
  Repository<SessionEntity> _repository;
  SessionEntity? _currentSession;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Set<Marker> _markers = {};

  SessionController(this._repository);

  SessionEntity? get currentSession => _currentSession;
  bool get isSessionActive => _currentSession != null && _currentSession!.endTime == null;
  Duration get elapsed => _elapsed;
  Set<Marker> get markers => _markers;

  void updateRepository(Repository<SessionEntity>? repo) {
    if (repo != null) {
      _repository = repo;
    }
  }

  void updateMarkers(List<PlaceEntity> places) {
    _markers = places.map((place) => Marker(
      markerId: MarkerId(place.id),
      position: LatLng(place.latitude, place.longitude),
      infoWindow: InfoWindow(title: place.name),
    )).toSet();
    notifyListeners();
  }

  Future<void> startSession({
    required String subjectId,
    required String placeId,
    required double latitude,
    required double longitude,
  }) async {
    _currentSession = SessionEntity(
      id: '',
      startTime: DateTime.now(),
      subjectId: subjectId,
      placeId: placeId,
      latitude: latitude,
      longitude: longitude,
    );
    _startTimer();
    notifyListeners();
  }

  Future<void> stopSession(int focusLevel) async {
    if (_currentSession == null) return;

    final sessionToSave = SessionEntity(
      id: _currentSession!.id,
      startTime: _currentSession!.startTime,
      endTime: DateTime.now(),
      subjectId: _currentSession!.subjectId,
      placeId: _currentSession!.placeId,
      focusLevel: focusLevel,
      latitude: _currentSession!.latitude,
      longitude: _currentSession!.longitude,
    );

    await _repository.save(sessionToSave);
    _stopTimer();
    _currentSession = null;
    notifyListeners();
  }

  void _startTimer() {
    _elapsed = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSession != null) {
        _elapsed = DateTime.now().difference(_currentSession!.startTime);
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _elapsed = Duration.zero;
  }
}

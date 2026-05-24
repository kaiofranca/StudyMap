import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../domain/session_entity.dart';
import '../../../core/domain/repository.dart';
import '../../../core/notifications/notification_service.dart';
import '../../places/domain/place_entity.dart';

class SessionController extends ChangeNotifier {
  Repository<SessionEntity> _repository;
  SessionEntity? _currentSession;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Set<Marker> _markers = {};
  
  String? _currentSubjectName;
  String? _currentPlaceName;
  bool _isPaused = false;
  Duration _accumulatedTime = Duration.zero;
  DateTime? _lastStartTime;

  SessionController(this._repository);

  SessionEntity? get currentSession => _currentSession;
  bool get isSessionActive => _currentSession != null && _currentSession!.endTime == null;
  bool get isPaused => _isPaused;
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
    required String subjectName,
    required String placeId,
    required String placeName,
    required double latitude,
    required double longitude,
  }) async {
    _currentSession = SessionEntity(
      id: '',
      startTime: DateTime.now(),
      subjectId: subjectId,
      subjectName: subjectName,
      placeId: placeId,
      placeName: placeName,
      latitude: latitude,
      longitude: longitude,
    );
    _currentSubjectName = subjectName;
    _currentPlaceName = placeName;
    _isPaused = false;
    _accumulatedTime = Duration.zero;
    _lastStartTime = DateTime.now();
    
    _startTimer();
    NotificationService.showSessionOngoingNotification(subjectName: subjectName);
    notifyListeners();
  }

  void pauseSession() {
    if (!isSessionActive || _isPaused) return;

    _isPaused = true;
    if (_lastStartTime != null) {
      _accumulatedTime += DateTime.now().difference(_lastStartTime!);
      _lastStartTime = null;
    }
    
    _stopTimer();
    NotificationService.cancelSessionNotification();
    notifyListeners();
  }

  void resumeSession() {
    if (!isSessionActive || !_isPaused || _currentSubjectName == null) return;

    _isPaused = false;
    _lastStartTime = DateTime.now();
    
    _startTimer();
    NotificationService.showSessionOngoingNotification(subjectName: _currentSubjectName!);
    notifyListeners();
  }

  Future<void> stopSession(int focusLevel) async {
    if (_currentSession == null) return;

    if (!_isPaused && _lastStartTime != null) {
      _accumulatedTime += DateTime.now().difference(_lastStartTime!);
    }

    final sessionToSave = SessionEntity(
      id: _currentSession!.id,
      startTime: _currentSession!.startTime,
      endTime: DateTime.now(),
      subjectId: _currentSession!.subjectId,
      subjectName: _currentSubjectName,
      placeId: _currentSession!.placeId,
      placeName: _currentPlaceName,
      focusLevel: focusLevel,
      latitude: _currentSession!.latitude,
      longitude: _currentSession!.longitude,
    );

    await _repository.save(sessionToSave);
    _stopTimer();
    _currentSession = null;
    _currentSubjectName = null;
    _currentPlaceName = null;
    _accumulatedTime = Duration.zero;
    _lastStartTime = null;
    _isPaused = false;
    
    NotificationService.cancelSessionNotification();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSession != null) {
        if (!_isPaused && _lastStartTime != null) {
          _elapsed = _accumulatedTime + DateTime.now().difference(_lastStartTime!);
        } else {
          _elapsed = _accumulatedTime;
        }
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    // Não zeramos _elapsed aqui para manter o valor na UI se pausado
  }
}

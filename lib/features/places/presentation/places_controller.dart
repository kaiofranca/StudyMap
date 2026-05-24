import 'package:flutter/material.dart';
import '../domain/place_entity.dart';
import '../../../core/domain/repository.dart';

class PlacesController extends ChangeNotifier {
  Repository<PlaceEntity> _repository;
  List<PlaceEntity> _places = [];
  bool _isLoading = false;

  PlacesController(this._repository);

  List<PlaceEntity> get places => _places;
  bool get isLoading => _isLoading;

  void updateRepository(Repository<PlaceEntity>? repo) {
    if (repo != null) {
      _repository = repo;
      loadPlaces();
    }
  }

  Future<void> loadPlaces() async {
    _setLoading(true);
    try {
      _places = await _repository.getAll();
    } finally {
      _setLoading(false);
    }
  }

  Future<PlaceEntity> addPlace(String name, double latitude, double longitude) async {
    final newPlace = PlaceEntity(
      id: '',
      name: name,
      latitude: latitude,
      longitude: longitude,
    );
    final id = await _repository.save(newPlace);
    await loadPlaces();
    return newPlace.copyWith(id: id);
  }

  Future<void> deletePlace(String id) async {
    await _repository.delete(id);
    await loadPlaces();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

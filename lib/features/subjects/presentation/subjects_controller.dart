import 'package:flutter/material.dart';
import '../domain/subject_entity.dart';
import '../../../core/domain/repository.dart';

class SubjectsController extends ChangeNotifier {
  Repository<SubjectEntity> _repository;
  List<SubjectEntity> _subjects = [];
  bool _isLoading = false;

  SubjectsController(this._repository);

  List<SubjectEntity> get subjects => _subjects;
  bool get isLoading => _isLoading;

  void updateRepository(Repository<SubjectEntity>? repo) {
    if (repo != null) {
      _repository = repo;
      loadSubjects();
    }
  }

  Future<void> loadSubjects() async {
    _setLoading(true);
    try {
      _subjects = await _repository.getAll();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addSubject(String name) async {
    final newSubject = SubjectEntity(id: '', name: name);
    await _repository.save(newSubject);
    await loadSubjects();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

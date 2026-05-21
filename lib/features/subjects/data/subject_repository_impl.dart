import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/subject_entity.dart';
import '../../../core/domain/repository.dart';

class SubjectRepositoryImpl implements Repository<SubjectEntity> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  SubjectRepositoryImpl(this.userId);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(userId).collection('subjects');

  @override
  Future<List<SubjectEntity>> getAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => SubjectEntity.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<SubjectEntity?> getById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return SubjectEntity.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<void> save(SubjectEntity entity) async {
    if (entity.id.isEmpty) {
      await _collection.add(entity.toMap());
    } else {
      await _collection.doc(entity.id).set(entity.toMap());
    }
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/session_entity.dart';
import '../../../core/domain/repository.dart';

class SessionRepositoryImpl implements Repository<SessionEntity> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  SessionRepositoryImpl(this.userId);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(userId).collection('sessions');

  @override
  Future<List<SessionEntity>> getAll() async {
    final snapshot = await _collection.orderBy('startTime', descending: true).get();
    return snapshot.docs
        .map((doc) => SessionEntity.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<SessionEntity?> getById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return SessionEntity.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<void> save(SessionEntity entity) async {
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

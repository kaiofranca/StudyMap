import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/place_entity.dart';
import '../../../core/domain/repository.dart';

class PlaceRepositoryImpl implements Repository<PlaceEntity> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  PlaceRepositoryImpl(this.userId);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(userId).collection('places');

  @override
  Future<List<PlaceEntity>> getAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => PlaceEntity.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<PlaceEntity?> getById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return PlaceEntity.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<String> save(PlaceEntity entity) async {
    if (entity.id.isEmpty) {
      final doc = await _collection.add(entity.toMap());
      return doc.id;
    } else {
      await _collection.doc(entity.id).set(entity.toMap());
      return entity.id;
    }
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}

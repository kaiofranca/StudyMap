import '../../../core/domain/entity.dart';

class SubjectEntity extends Entity {
  final String name;

  const SubjectEntity({
    required super.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory SubjectEntity.fromMap(String id, Map<String, dynamic> map) {
    return SubjectEntity(
      id: id,
      name: map['name'] ?? '',
    );
  }
}

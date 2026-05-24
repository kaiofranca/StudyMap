import '../../../core/domain/entity.dart';

class SubjectEntity extends Entity {
  final String name;

  const SubjectEntity({
    required super.id,
    required this.name,
  });

  SubjectEntity copyWith({
    String? id,
    String? name,
  }) {
    return SubjectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

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

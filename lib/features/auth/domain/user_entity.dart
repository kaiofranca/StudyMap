import '../../../core/domain/entity.dart';

class UserEntity extends Entity {
  final String email;
  final String? name;
  final String? photoUrl;

  const UserEntity({
    required super.id,
    required this.email,
    this.name,
    this.photoUrl,
  });
}

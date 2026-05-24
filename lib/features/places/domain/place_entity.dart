import '../../../core/domain/entity.dart';

class PlaceEntity extends Entity {
  final String name;
  final double latitude;
  final double longitude;

  const PlaceEntity({
    required super.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  PlaceEntity copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
  }) {
    return PlaceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory PlaceEntity.fromMap(String id, Map<String, dynamic> map) {
    return PlaceEntity(
      id: id,
      name: map['name'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
    );
  }
}

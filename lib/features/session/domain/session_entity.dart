import '../../../core/domain/entity.dart';

class SessionEntity extends Entity {
  final DateTime startTime;
  final DateTime? endTime;
  final String? subjectId;
  final String? subjectName;
  final String? placeId;
  final String? placeName;
  final int? focusLevel; // 1-5
  final double? productivityIndex;
  final double latitude;
  final double longitude;

  const SessionEntity({
    required super.id,
    required this.startTime,
    this.endTime,
    this.subjectId,
    this.subjectName,
    this.placeId,
    this.placeName,
    this.focusLevel,
    this.productivityIndex,
    required this.latitude,
    required this.longitude,
  });

  double get durationInMinutes {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inSeconds / 60.0;
  }

  double calculateProductivity() {
    if (focusLevel == null || endTime == null) return 0;
    final durationHours = durationInMinutes / 60.0;
    return focusLevel! * durationHours;
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'subjectId': subjectId,
      'subjectName': subjectName,
      'placeId': placeId,
      'placeName': placeName,
      'focusLevel': focusLevel,
      'productivityIndex': productivityIndex ?? calculateProductivity(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory SessionEntity.fromMap(String id, Map<String, dynamic> map) {
    return SessionEntity(
      id: id,
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      subjectId: map['subjectId'],
      subjectName: map['subjectName'],
      placeId: map['placeId'],
      placeName: map['placeName'],
      focusLevel: map['focusLevel'],
      productivityIndex: (map['productivityIndex'] ?? 0.0).toDouble(),
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
    );
  }
}

import '../../session/domain/session_entity.dart';

class ProductivityCalculator {
  static double calculate(SessionEntity session) {
    return session.calculateProductivity();
  }

  static double calculateTotal(List<SessionEntity> sessions) {
    return sessions.fold(0, (total, s) => total + calculate(s));
  }
}

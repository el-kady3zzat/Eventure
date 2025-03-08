import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';

abstract class NotificationRepository {
  Future<Either<Failure, void>> registerFcmToken();
  Future<Either<Failure, void>> toggleNotificationChannel(
    String channelId,
    bool isEnabled,
  );
  Future<Either<Failure, Map<String, bool>>> getNotificationSettings();
}

enum NotificationType {
  like,
  comment,
  connection,
  group,
}

class NotificationModel {
  final String notificationId;
  final String userId;
  final NotificationType type;
  final String referenceId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.referenceId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notification_id'] ?? '',
      userId: json['user_id'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.like,
      ),
      referenceId: json['reference_id'] ?? '',
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'user_id': userId,
      'type': type.toString().split('.').last,
      'reference_id': referenceId,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

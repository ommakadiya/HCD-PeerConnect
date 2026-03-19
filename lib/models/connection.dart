enum ConnectionStatus {
  pending,
  accepted,
  blocked,
}

class Connection {
  final String connectionId;
  final String userId1;
  final String userId2;
  final ConnectionStatus status;
  final DateTime createdAt;

  Connection({
    required this.connectionId,
    required this.userId1,
    required this.userId2,
    required this.status,
    required this.createdAt,
  });

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      connectionId: json['connection_id'] ?? '',
      userId1: json['user_id_1'] ?? '',
      userId2: json['user_id_2'] ?? '',
      status: ConnectionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ConnectionStatus.pending,
      ),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'connection_id': connectionId,
      'user_id_1': userId1,
      'user_id_2': userId2,
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

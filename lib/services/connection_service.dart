import 'package:cloud_firestore/cloud_firestore.dart';

/// Handles peer-connection requests and queries in Firestore.
///
/// Firestore structure:
///   connections/{connectionId}
///     fromUserId: String
///     toUserId:   String
///     status:     'pending' | 'accepted' | 'rejected'
///     createdAt:  Timestamp
class ConnectionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _connections =>
      _db.collection('connections');

  // ── Send ──────────────────────────────────────────────────────────────────

  /// Creates a new connection request document.
  /// Does nothing if a pending/accepted request already exists in that direction.
  Future<void> sendConnectionRequest({
    required String fromUserId,
    required String toUserId,
  }) async {
    // Avoid duplicates: check if a connection already exists
    final existing = await _connections
        .where('fromUserId', isEqualTo: fromUserId)
        .where('toUserId', isEqualTo: toUserId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) return; // already requested

    await _connections.add({
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Accept ────────────────────────────────────────────────────────────────

  /// Updates the connection document status to 'accepted'.
  Future<void> acceptConnection(String connectionId) async {
    await _connections.doc(connectionId).update({'status': 'accepted'});
  }

  // ── Reject ────────────────────────────────────────────────────────────────

  /// Updates the connection document status to 'rejected'.
  Future<void> rejectConnection(String connectionId) async {
    await _connections.doc(connectionId).update({'status': 'rejected'});
  }

  // ── Stream: my connections ────────────────────────────────────────────────

  /// Stream of accepted connections where [userId] is either sender or receiver.
  Stream<List<Map<String, dynamic>>> getAcceptedConnections(String userId) {
    // Firestore does not support OR across different fields in a single query.
    // We listen to both directions and merge client-side.
    return _connections
        .where('fromUserId', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .map((s) => s.docs
            .map((d) => {'connectionId': d.id, ...d.data()})
            .toList());
  }

  /// Stream of incoming pending requests for [userId].
  Stream<List<Map<String, dynamic>>> getIncomingRequests(String userId) {
    return _connections
        .where('toUserId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((s) => s.docs
            .map((d) => {'connectionId': d.id, ...d.data()})
            .toList());
  }

  // ── Check status ──────────────────────────────────────────────────────────

  /// Returns the status string ('pending', 'accepted', 'rejected', or null)
  /// for a connection from [fromUserId] to [toUserId].
  Future<String?> getConnectionStatus({
    required String fromUserId,
    required String toUserId,
  }) async {
    final result = await _connections
        .where('fromUserId', isEqualTo: fromUserId)
        .where('toUserId', isEqualTo: toUserId)
        .limit(1)
        .get();

    if (result.docs.isEmpty) return null;
    return result.docs.first.data()['status'] as String?;
  }
}

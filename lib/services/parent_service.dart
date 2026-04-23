import '../models/parent_child_link.dart';

class ParentService {
  final List<ParentChildLink> _links = [];

  /// Returns the current list of parent-child links.
  List<ParentChildLink> get links => List.unmodifiable(_links);

  /// Simulates sending an invite. 
  /// For simplicity, we use [parentEmail] as the parentId placeholder.
  /// In a full backend implementation, you would resolve the email to an actual User ID.
  Future<void> sendInvite(String parentEmail, String childId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate backend request

    // Check if link already exists to prevent duplicates
    final exists = _links.any(
      (link) => link.parentId == parentEmail && link.childId == childId,
    );

    if (!exists) {
      _links.add(
        ParentChildLink(
          parentId: parentEmail,
          childId: childId,
          status: 'pending',
        ),
      );
    }
  }

  /// Updates the status of a specific invite from 'pending' to 'accepted'.
  Future<void> acceptInvite(String parentId, String childId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate backend request

    final index = _links.indexWhere(
      (link) => link.parentId == parentId && link.childId == childId,
    );

    if (index != -1) {
      // Create a new instance because ParentChildLink fields are final
      _links[index] = ParentChildLink(
        parentId: parentId,
        childId: childId,
        status: 'accepted',
      );
    }
  }
}

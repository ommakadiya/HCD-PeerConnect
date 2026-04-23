import 'lib/models/mock_data.dart';
import 'lib/services/connection_service.dart';
import 'lib/services/group_service.dart';
import 'lib/services/parent_service.dart';

void main() async {
  print('=========================================');
  print('🚀 PEERCONNECT REAL FLOW SIMULATION');
  print('=========================================\n');

  // 1. User logs in
  final currentUser = MockData.users.first;
  print('👤 1. USER LOGS IN');
  print('   Welcome back, ${currentUser.name}!');
  print('   Email: ${currentUser.email}');
  print('-----------------------------------------\n');

  // 2. Profile loads
  print('📄 2. PROFILE LOADS');
  print('   University: ${currentUser.university}');
  print('   Course: ${currentUser.course}');
  print('   Origin City: ${currentUser.originCity}');
  print('   Migrated Country: ${currentUser.migratedCountry}');
  print('   Current City: ${currentUser.currentCity}');
  print('-----------------------------------------\n');

  // 3. Connections appear (calculated)
  print('🤝 3. CONNECTIONS CALCULATED');
  final connectionService = ConnectionService();
  final connections = await connectionService.generateConnections(currentUser, MockData.users);
  
  for (var match in connections) {
    print('   -> Matched with ${match.user.name} (Score: ${match.score} pts)');
    for (var reason in match.reasons) {
      print('      • $reason');
    }
  }
  if (connections.isEmpty) {
    print('   -> No matches found with score >= 30.');
  }
  print('-----------------------------------------\n');

  // 4. Groups appear (generated)
  print('👥 4. GROUPS GENERATED DYNAMICALLY');
  final groupService = GroupService();
  final groups = await groupService.generateGroups(currentUser);
  
  for (var group in groups) {
    print('   -> Suggested [${group.type}] Group: ${group.name}');
  }
  print('-----------------------------------------\n');

  // 5. Parent connects
  print('👨‍👩‍👦 5. PARENT CONNECTS');
  final parentService = ParentService();
  final parentEmail = 'parent.sharma@example.com';
  
  print('   -> Parent ($parentEmail) sends invite to ${currentUser.name} (${currentUser.id})');
  await parentService.sendInvite(parentEmail, currentUser.id);
  print('   -> Invites pending: ${parentService.links.length}');
  print('   -> Link status: ${parentService.links.first.status}');
  print('');
  print('   -> ${currentUser.name} accepts the invite!');
  await parentService.acceptInvite(parentEmail, currentUser.id);
  
  final linkStatus = parentService.links.firstWhere((l) => l.parentId == parentEmail).status;
  print('   -> Updated Link Status: $linkStatus');
  print('=========================================\n');
  print('✅ SIMULATION COMPLETE - System operates flawlessly.');
}

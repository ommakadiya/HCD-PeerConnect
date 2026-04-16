import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/connection_service.dart';
import '../services/user_service.dart';

enum ConnectionType {
  parentMutual,
  studentRecommendation,
  sharedLocationOrUni,
}

class RecommendedConnection {
  final String userId;
  final String name;
  final String description;
  final ConnectionType type;

  RecommendedConnection({
    required this.userId,
    required this.name,
    required this.description,
    required this.type,
  });
}

class StudentConnectionsScreen extends StatefulWidget {
  const StudentConnectionsScreen({super.key});

  @override
  State<StudentConnectionsScreen> createState() =>
      _StudentConnectionsScreenState();
}

class _StudentConnectionsScreenState extends State<StudentConnectionsScreen> {
  final ConnectionService _connectionService = ConnectionService();

  List<RecommendedConnection> _recommendations = [];
  // Tracks pending sent requests: userId → status ('pending'|'accepted')
  final Map<String, String> _requestStatus = {};
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    final provider = context.read<AppStateProvider>();
    final userId = provider.userId;
    final migratedCity = provider.migratedCity;
    final originCity = provider.originCity;

    if (userId.isEmpty) {
      // Fallback: show empty list if not logged in
      setState(() => _isLoading = false);
      return;
    }

    try {
      final userService = UserService();
      // Query users by migratedCity (shared destination)
      final snapshot = await userService
          .recommendedConnections(
            currentUserId: userId,
            migratedCity: migratedCity,
            originCity: originCity,
          )
          .first;

      final recs = snapshot.map<RecommendedConnection>((data) {
        return RecommendedConnection(
          userId: data['id'] as String? ?? '',
          name: data['name'] as String? ?? 'Unknown',
          description:
              'Also in ${(data['childProfile'] as Map?)?['migratedCity'] ?? migratedCity}',
          type: ConnectionType.sharedLocationOrUni,
        );
      }).toList();

      // Check existing connection statuses for each recommended user
      for (final rec in recs) {
        final status = await _connectionService.getConnectionStatus(
          fromUserId: userId,
          toUserId: rec.userId,
        );
        if (status != null) {
          _requestStatus[rec.userId] = status;
        }
      }

      if (mounted) {
        setState(() {
          _recommendations = recs;
          _isLoading = false;
        });
      }
    } catch (_) {
      // If Firestore fails (e.g., index not ready), fall back to static data
      if (mounted) {
        setState(() {
          _recommendations = _fallbackConnections();
          _isLoading = false;
        });
      }
    }
  }

  List<RecommendedConnection> _fallbackConnections() => [
        RecommendedConnection(
          userId: 'dummy1',
          name: 'Alex Johnson',
          description: 'Mutual connection via your parents',
          type: ConnectionType.parentMutual,
        ),
        RecommendedConnection(
          userId: 'dummy2',
          name: 'Sarah Smith',
          description: 'Recommended student connection',
          type: ConnectionType.studentRecommendation,
        ),
        RecommendedConnection(
          userId: 'dummy3',
          name: 'Michael Lee',
          description: 'Also from Mumbai & going to Oxford',
          type: ConnectionType.sharedLocationOrUni,
        ),
        RecommendedConnection(
          userId: 'dummy4',
          name: 'Emily Davis',
          description: 'Mutual connection via your parents',
          type: ConnectionType.parentMutual,
        ),
        RecommendedConnection(
          userId: 'dummy5',
          name: 'David Wilson',
          description: 'Studying similar courses at your Uni',
          type: ConnectionType.sharedLocationOrUni,
        ),
      ];

  Future<void> _sendRequest(String toUserId) async {
    final provider = context.read<AppStateProvider>();
    if (provider.userId.isEmpty || toUserId.startsWith('dummy')) {
      // Demo mode: just update UI
      setState(() => _requestStatus[toUserId] = 'pending');
      return;
    }

    setState(() => _requestStatus[toUserId] = 'pending');
    try {
      await _connectionService.sendConnectionRequest(
        fromUserId: provider.userId,
        toUserId: toUserId,
      );
    } catch (e) {
      if (mounted) {
        setState(() => _requestStatus.remove(toUserId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send request: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Color _getThemeColor(ConnectionType type) {
    switch (type) {
      case ConnectionType.parentMutual:
        return Colors.green;
      case ConnectionType.studentRecommendation:
        return Colors.blue;
      case ConnectionType.sharedLocationOrUni:
        return const Color(0xFF003366);
    }
  }

  Color _getBackgroundColor(ConnectionType type) {
    switch (type) {
      case ConnectionType.parentMutual:
        return Colors.green.shade50;
      case ConnectionType.studentRecommendation:
        return Colors.blue.shade50;
      case ConnectionType.sharedLocationOrUni:
        return Colors.blue.shade50;
    }
  }

  IconData _getIcon(ConnectionType type) {
    switch (type) {
      case ConnectionType.parentMutual:
        return Icons.family_restroom;
      case ConnectionType.studentRecommendation:
        return Icons.person_add;
      case ConnectionType.sharedLocationOrUni:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _recommendations
        .where((c) =>
            _searchQuery.isEmpty ||
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Connect')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search connections...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Recommended Connections',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No connections found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final connection = filtered[index];
                          final themeColor = _getThemeColor(connection.type);
                          final bgColor = _getBackgroundColor(connection.type);
                          final iconData = _getIcon(connection.type);
                          final status = _requestStatus[connection.userId];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: themeColor.withOpacity(0.3)),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              leading: CircleAvatar(
                                backgroundColor: themeColor.withOpacity(0.2),
                                child: Icon(iconData, color: themeColor),
                              ),
                              title: Text(
                                connection.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: themeColor.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  connection.description,
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 13),
                                ),
                              ),
                              trailing: status == 'pending'
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Pending',
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 13),
                                      ),
                                    )
                                  : status == 'accepted'
                                      ? Icon(Icons.check_circle,
                                          color: Colors.green.shade400)
                                      : ElevatedButton(
                                          onPressed: () =>
                                              _sendRequest(connection.userId),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: themeColor,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                          ),
                                          child: const Text('Connect'),
                                        ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

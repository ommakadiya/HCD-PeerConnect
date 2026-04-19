import 'package:flutter/material.dart';

enum ConnectionType {
  parentMutual,
  studentRecommendation,
  sharedLocationOrUni,
}

class RecommendedConnection {
  final String name;
  final String description;
  final ConnectionType type;

  RecommendedConnection({
    required this.name,
    required this.description,
    required this.type,
  });
}

class StudentConnectionsScreen extends StatefulWidget {
  const StudentConnectionsScreen({super.key});

  @override
  State<StudentConnectionsScreen> createState() => _StudentConnectionsScreenState();
}

class _StudentConnectionsScreenState extends State<StudentConnectionsScreen> {
  final List<RecommendedConnection> dummyConnections = [
    RecommendedConnection(
      name: 'Alex Johnson',
      description: 'Mutual connection via your parents',
      type: ConnectionType.parentMutual,
    ),
    RecommendedConnection(
      name: 'Sarah Smith',
      description: 'Recommended student connection',
      type: ConnectionType.studentRecommendation,
    ),
    RecommendedConnection(
      name: 'Michael Lee',
      description: 'Also from Mumbai & going to Oxford',
      type: ConnectionType.sharedLocationOrUni,
    ),
    RecommendedConnection(
      name: 'Emily Davis',
      description: 'Mutual connection via your parents',
      type: ConnectionType.parentMutual,
    ),
    RecommendedConnection(
      name: 'David Wilson',
      description: 'Studying similar courses at your Uni',
      type: ConnectionType.sharedLocationOrUni,
    ),
    RecommendedConnection(
      name: 'Jessica Brown',
      description: 'Recommended student connection',
      type: ConnectionType.studentRecommendation,
    ),
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search connections...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
          
          // Section Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Recommended Connections',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Recommendations List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: dummyConnections.length,
              itemBuilder: (context, index) {
                final connection = dummyConnections[index];
                final themeColor = _getThemeColor(connection.type);
                final bgColor = _getBackgroundColor(connection.type);
                final iconData = _getIcon(connection.type);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: themeColor.withOpacity(0.3)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

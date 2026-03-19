import 'package:flutter/material.dart';

class ParentConnectionsScreen extends StatelessWidget {
  const ParentConnectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Community'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.family_restroom, size: 80, color: Colors.green),
              SizedBox(height: 20),
              Text('Connect with Parents', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Share advice, plan events, and support the community together.', style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

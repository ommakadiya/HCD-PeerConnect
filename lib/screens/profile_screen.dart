import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 20),
          const Center(child: Text('User Name', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          const Center(child: Text('Role: Parent', style: TextStyle(fontSize: 18, color: Colors.grey))),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.settings, size: 30),
            title: const Text('Settings', style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, size: 30),
            title: const Text('Privacy', style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, size: 30, color: Colors.red),
            title: const Text('Logout', style: TextStyle(fontSize: 18, color: Colors.red)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

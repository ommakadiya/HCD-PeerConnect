import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _themeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppStateProvider>(context);
    final isChild = provider.role == 'child';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Gradient and Profile Header
            Stack(
              children: [
                Container(
                  height: 230,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFD4E6F1), Color(0xFFD1F2EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      // Custom App Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        child: Row(
                          children: [
                            Image.asset('assets/app bar logo - Copy.png', height: 28),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Profile & Settings',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Profile Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Icon(Icons.person, size: 40, color: Colors.grey.shade500),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.edit, size: 12, color: Colors.grey.shade700),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            // User Info from Provider
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.name.isNotEmpty ? provider.name : 'Your Name',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isChild ? const Color(0xFF003366) : const Color(0xFF003366),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isChild ? 'Child' : 'Parent',
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 14, color: Colors.grey.shade700),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          provider.originCity.isNotEmpty ? provider.originCity : 'Your City',
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Profile Information'),
                  _buildCard(
                    children: isChild
                        ? [
                            _buildInfoRow(Icons.person, 'Name', provider.name),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.location_city, 'Origin City', provider.originCity),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.flight_land, 'Migrated City', provider.migratedCity),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.phone, 'Phone', provider.phone),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.home, 'Address', provider.address),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.work, 'Occupation', provider.occupation),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.person_outline, 'Parent', provider.parentName),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.email, 'Parent Email', provider.parentEmail),
                          ]
                        : [
                            _buildInfoRow(Icons.person, 'Name', provider.name),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.location_city, 'Origin City', provider.originCity),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.phone, 'Phone', provider.phone),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.home, 'Address', provider.address),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.work, 'Occupation', provider.occupation),
                            if (provider.parentDetails.isNotEmpty) ...[
                              const Divider(height: 1, indent: 50),
                              _buildInfoRow(Icons.child_care, 'Child Email', provider.parentDetails[0].childEmailId),
                            ],
                            if (provider.parentDetails.length > 1) ...[
                              const Divider(height: 1, indent: 50),
                              _buildInfoRow(Icons.person_add, 'Parent 2', provider.parentDetails[1].name),
                            ],
                          ],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Account Settings'),
                  _buildCard(
                    children: [
                      _buildSettingsTile(Icons.person_outline, 'Edit Profile'),
                      const Divider(height: 1, indent: 50),
                      _buildSettingsTile(Icons.lock_outline, 'Change Password'),
                      const Divider(height: 1, indent: 50),
                      _buildSettingsTile(Icons.privacy_tip_outlined, 'Privacy Settings'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('App Settings'),
                  _buildCard(
                    children: [
                      _buildSwitchTile(Icons.notifications_outlined, 'Notifications', _notificationsEnabled, (val) {
                        setState(() => _notificationsEnabled = val);
                      }),
                      const Divider(height: 1, indent: 50),
                      ListTile(
                        leading: Icon(Icons.language, color: Colors.grey.shade700),
                        title: const Text('Language', style: TextStyle(fontWeight: FontWeight.w500)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('English', style: TextStyle(color: Colors.grey.shade600)),
                            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 50),
                      _buildSwitchTile(Icons.lightbulb_outline, 'Theme', _themeEnabled, (val) {
                        setState(() => _themeEnabled = val);
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Security & Logout'),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.shade200, width: 1.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003366),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout', style: TextStyle(fontSize: 16)),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF003366)),
      title: Text(value.isNotEmpty ? value : '—', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildSettingsTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF003366)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF003366)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF003366),
        activeTrackColor: const Color(0xFFD4E6F1),
      ),
    );
  }
}

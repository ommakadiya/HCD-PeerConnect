import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'main_layout.dart';

class ChildProfileSetupScreen extends StatefulWidget {
  const ChildProfileSetupScreen({super.key});

  @override
  State<ChildProfileSetupScreen> createState() => _ChildProfileSetupScreenState();
}

class _ChildProfileSetupScreenState extends State<ChildProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  final _nameController = TextEditingController();
  final _originCityController = TextEditingController();
  final _migratedCityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _occupationController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentEmailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _originCityController.dispose();
    _migratedCityController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _occupationController.dispose();
    _parentNameController.dispose();
    _parentEmailController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final provider = Provider.of<AppStateProvider>(context, listen: false);
      await provider.completeChildProfile(
        name: _nameController.text.trim(),
        originCity: _originCityController.text.trim(),
        migratedCity: _migratedCityController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        occupation: _occupationController.text.trim(),
        parentName: _parentNameController.text.trim(),
        parentEmail: _parentEmailController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainLayout()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                    ),
                    const Expanded(
                      child: Text(
                        'Child Profile Setup',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),

                // Profile Photo
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Image picker
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(Icons.person, size: 50, color: Colors.grey.shade500),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF003366),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text('Tap to add profile photo', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
                const SizedBox(height: 30),

                // Personal Details Section
                _buildSectionTitle('Personal Details'),
                const SizedBox(height: 12),
                _buildTextField(_nameController, 'Full Name', Icons.person),
                const SizedBox(height: 14),
                _buildTextField(_originCityController, 'Origin City', Icons.location_city),
                const SizedBox(height: 14),
                _buildTextField(_migratedCityController, 'Migrated City', Icons.flight_land),
                const SizedBox(height: 14),
                _buildTextField(_phoneController, 'Phone Number', Icons.phone, keyboard: TextInputType.phone),
                const SizedBox(height: 14),
                _buildTextField(_addressController, 'Address', Icons.home),
                const SizedBox(height: 14),
                _buildTextField(_occupationController, 'Occupation', Icons.work),
                const SizedBox(height: 30),

                // Parent Details Section
                _buildSectionTitle('Parent Details'),
                const SizedBox(height: 4),
                Text(
                  'Assign at least one parent to your profile',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                _buildTextField(_parentNameController, 'Parent Name', Icons.person_outline),
                const SizedBox(height: 14),
                _buildTextField(_parentEmailController, 'Parent Email ID', Icons.email_outlined, keyboard: TextInputType.emailAddress),
                const SizedBox(height: 40),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isSaving ? null : _submitForm,
                    child: _isSaving
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text('Complete Setup',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF003366)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF003366), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

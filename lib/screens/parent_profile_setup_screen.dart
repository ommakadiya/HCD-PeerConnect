import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'main_layout.dart';

class ParentProfileSetupScreen extends StatefulWidget {
  const ParentProfileSetupScreen({super.key});

  @override
  State<ParentProfileSetupScreen> createState() => _ParentProfileSetupScreenState();
}

class _ParentProfileSetupScreenState extends State<ParentProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _parentCount = 1; // 1 or 2
  bool _isSaving = false;

  // Parent 1 controllers
  final _name1 = TextEditingController();
  final _originCity1 = TextEditingController();
  final _phone1 = TextEditingController();
  final _address1 = TextEditingController();
  final _occupation1 = TextEditingController();
  final _childEmail1 = TextEditingController();

  // Parent 2 controllers
  final _name2 = TextEditingController();
  final _originCity2 = TextEditingController();
  final _phone2 = TextEditingController();
  final _address2 = TextEditingController();
  final _occupation2 = TextEditingController();
  final _childEmail2 = TextEditingController();

  @override
  void dispose() {
    _name1.dispose();
    _originCity1.dispose();
    _phone1.dispose();
    _address1.dispose();
    _occupation1.dispose();
    _childEmail1.dispose();
    _name2.dispose();
    _originCity2.dispose();
    _phone2.dispose();
    _address2.dispose();
    _occupation2.dispose();
    _childEmail2.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final provider = Provider.of<AppStateProvider>(context, listen: false);

      List<ParentDetail> parents = [
        ParentDetail(
          name: _name1.text.trim(),
          originCity: _originCity1.text.trim(),
          phone: _phone1.text.trim(),
          address: _address1.text.trim(),
          occupation: _occupation1.text.trim(),
          childEmailId: _childEmail1.text.trim(),
        ),
      ];

      if (_parentCount == 2) {
        parents.add(
          ParentDetail(
            name: _name2.text.trim(),
            originCity: _originCity2.text.trim(),
            phone: _phone2.text.trim(),
            address: _address2.text.trim(),
            occupation: _occupation2.text.trim(),
            childEmailId: _childEmail2.text.trim(),
          ),
        );
      }

      await provider.completeParentProfile(parents: parents);
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
                        'Parent Profile Setup',
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

                // ── Parent 1 ──
                _buildSectionTitle('Parent 1 Details'),
                const SizedBox(height: 12),
                _buildParentForm(
                  nameCtrl: _name1,
                  cityCtrl: _originCity1,
                  phoneCtrl: _phone1,
                  addressCtrl: _address1,
                  occupationCtrl: _occupation1,
                  childEmailCtrl: _childEmail1,
                ),
                const SizedBox(height: 24),

                // ── Add / Remove Parent 2 ──
                if (_parentCount < 2)
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _parentCount = 2),
                      icon: const Icon(Icons.person_add, color: Color(0xFF003366)),
                      label: const Text(
                        'Add Another Parent',
                        style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF003366)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                    ),
                  ),

                if (_parentCount == 2) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Parent 2 Details'),
                      TextButton(
                        onPressed: () => setState(() => _parentCount = 1),
                        child: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildParentForm(
                    nameCtrl: _name2,
                    cityCtrl: _originCity2,
                    phoneCtrl: _phone2,
                    addressCtrl: _address2,
                    occupationCtrl: _occupation2,
                    childEmailCtrl: _childEmail2,
                  ),
                ],
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

  Widget _buildParentForm({
    required TextEditingController nameCtrl,
    required TextEditingController cityCtrl,
    required TextEditingController phoneCtrl,
    required TextEditingController addressCtrl,
    required TextEditingController occupationCtrl,
    required TextEditingController childEmailCtrl,
  }) {
    return Column(
      children: [
        _buildTextField(nameCtrl, 'Full Name', Icons.person),
        const SizedBox(height: 14),
        _buildTextField(cityCtrl, 'Origin City', Icons.location_city),
        const SizedBox(height: 14),
        _buildTextField(phoneCtrl, 'Phone Number', Icons.phone, keyboard: TextInputType.phone),
        const SizedBox(height: 14),
        _buildTextField(addressCtrl, 'Address', Icons.home),
        const SizedBox(height: 14),
        _buildTextField(occupationCtrl, 'Occupation', Icons.work),
        const SizedBox(height: 14),
        _buildTextField(childEmailCtrl, 'Child ID / Child Email', Icons.child_care, keyboard: TextInputType.emailAddress),
      ],
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

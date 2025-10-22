import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../data/user_profile.dart';
import '../state/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/profile/edit';

  const EditProfileScreen({
    super.key,
    this.controllerOverride,
  });

  final ProfileController? controllerOverride;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _designationController = TextEditingController();
  final _companyController = TextEditingController();
  final _countryController = TextEditingController();

  String? _profileImage;
  bool _initialised = false;
  bool _canSubmit = false;

  ProfileController get _controller =>
      widget.controllerOverride ??
      Provider.of<ProfileController>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateValidity);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateValidity);
    _nameController.dispose();
    _phoneController.dispose();
    _designationController.dispose();
    _companyController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialised) {
      _prefillFromProfile();
    }
  }

  void _prefillFromProfile() {
    final profile = _controller.profile;
    if (profile != null) {
      _nameController.text = profile.name ?? '';
      _phoneController.text = profile.phone ?? '';
      _designationController.text = profile.designation ?? '';
      _companyController.text = profile.companyName ?? '';
      _countryController.text = profile.country ?? '';
      _profileImage = profile.profileImage;
    } else {
      final user = FirebaseAuth.instance.currentUser;
      _nameController.text = user?.displayName ?? '';
    }
    _initialised = true;
    _updateValidity();
  }

  void _updateValidity() {
    final isValid = _nameController.text.trim().length >= 2;
    if (_canSubmit != isValid) {
      setState(() => _canSubmit = isValid);
    }
  }

  Future<void> _handlePickImage() async {
    try {
      final downloadUrl =
          await _controller.pickAndUploadImage(ImageSource.gallery);
      if (downloadUrl != null) {
        setState(() => _profileImage = downloadUrl);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image upload failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _handleSave(ProfileController controller) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to update your profile')),
      );
      return;
    }

    final current = controller.profile ??
        UserProfile(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
        );

    final updated = current.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      designation: _designationController.text.trim().isEmpty
          ? null
          : _designationController.text.trim(),
      companyName: _companyController.text.trim().isEmpty
          ? null
          : _companyController.text.trim(),
      country: _countryController.text.trim().isEmpty
          ? null
          : _countryController.text.trim(),
      profileImage: _profileImage,
    );

    try {
      await controller.save(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        widget.controllerOverride ?? context.watch<ProfileController>();
    final email = controller.profile?.email ??
        FirebaseAuth.instance.currentUser?.email ??
        '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: controller.isLoading && controller.profile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: _profileImage != null
                                ? NetworkImage(_profileImage!)
                                : null,
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.15),
                            child: _profileImage != null
                                ? null
                                : Text(
                                    _initialsFromName(_nameController.text),
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: -4,
                            right: -4,
                            child: InkWell(
                              onTap: controller.isLoading
                                  ? null
                                  : _handlePickImage,
                              borderRadius: BorderRadius.circular(24),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.primary,
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Email',
                      icon: Icons.email_outlined,
                      enabled: false,
                      initialValue: email,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        final pattern = RegExp(r'^[0-9+ \-]{7,15}$');
                        if (!pattern.hasMatch(value.trim())) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _designationController,
                      label: 'Designation',
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _companyController,
                      label: 'Company Name',
                      icon: Icons.business_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _countryController,
                      label: 'Country',
                      icon: Icons.public_outlined,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading || !_canSubmit
                            ? null
                            : () => _handleSave(controller),
                        child: controller.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? initialValue,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      enabled: enabled,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  String _initialsFromName(String value) {
    if (value.trim().isEmpty) return '?';
    return value
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
  }
}

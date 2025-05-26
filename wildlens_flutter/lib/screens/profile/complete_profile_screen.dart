import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/widgets/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CompleteProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  const CompleteProfileScreen({Key? key, required this.name, required this.email, required this.password}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  late TextEditingController _nameController;
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _biomeController = TextEditingController();
  File? _pickedImage;
  String? _avatarUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isLoggedIn = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image == null) return;
      setState(() {
        _isUploading = true;
        _error = null;
      });
      // Avatar upload will be deferred until after registration
      _pickedImage = File(image.path);
      _avatarUrl = null; // Will be set after registration
      setState(() {});
    } catch (e) {
      setState(() {
        _error = 'Erreur lors de la sélection de l\'image: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // Register the user with all info except avatar
      await ApiService().register({
        'name': _nameController.text.trim(),
        'email': widget.email,
        'password': widget.password,
        'bio': _bioController.text.trim(),
        'avatar': '',
        'favorite_biome': _biomeController.text.trim(),
      });
      // Log in to allow avatar upload
      await ApiService().login(widget.email, widget.password);
      // If an image was picked, upload it now
      if (_pickedImage != null) {
        final request = await ApiService().uploadAvatar(_pickedImage!);
        _avatarUrl = request['avatar_url'];
        // Update profile with avatar URL
        await ApiService().updateProfile({
          'name': _nameController.text.trim(),
          'email': widget.email,
          'bio': _bioController.text.trim(),
          'avatar': _avatarUrl ?? '',
          'favorite_biome': _biomeController.text.trim(),
          'password': '',
        });
      }
      setState(() {
        _isLoggedIn = true;
      });
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compléter le profil'),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.accent),
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: _isLoading && !_isLoggedIn
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Avatar preview and upload button
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!)
                                : (_avatarUrl != null && _avatarUrl!.isNotEmpty
                                    ? NetworkImage(_avatarUrl!)
                                    : null) as ImageProvider<Object>?,
                            child: _pickedImage == null && (_avatarUrl == null || _avatarUrl!.isEmpty)
                                ? const Icon(Icons.person, size: 48, color: Colors.white)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _isUploading ? null : _pickAndUploadImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: _isUploading
                                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _biomeController,
                      decoration: const InputDecoration(
                        labelText: 'Biome favori',
                        prefixIcon: Icon(Icons.eco),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                        ),
                        onPressed: _isLoading ? null : _saveProfile,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Enregistrer', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(_error!, style: const TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
} 
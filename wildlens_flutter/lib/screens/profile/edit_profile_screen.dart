import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/widgets/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const EditProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _avatarController;
  late TextEditingController _biomeController;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isUploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name'] ?? '');
    _bioController = TextEditingController(text: widget.userData['bio'] ?? '');
    _avatarController = TextEditingController(text: widget.userData['avatar'] ?? '');
    _biomeController = TextEditingController(text: widget.userData['favorite_biome'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _avatarController.dispose();
    _biomeController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await ApiService().updateProfile({
        'name': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'avatar': _avatarController.text.trim(),
        'favorite_biome': _biomeController.text.trim(),
        // Email and password are not changed here
        'email': widget.userData['email'],
        'password': '',
      });
      if (!mounted) return;
      Navigator.pop(context, true); // Indicate success
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

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image == null) return;
      setState(() {
        _isUploading = true;
        _error = null;
      });
      // Upload to backend
      final request = await ApiService().uploadAvatar(File(image.path));
      setState(() {
        _pickedImage = File(image.path);
        _avatarController.text = request['avatar_url'];
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du téléchargement de l\'image: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.accent),
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
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
                          : (_avatarController.text.isNotEmpty
                              ? NetworkImage(_avatarController.text)
                              : null) as ImageProvider<Object>?,
                      child: _pickedImage == null && _avatarController.text.isEmpty
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
                controller: _avatarController,
                decoration: const InputDecoration(
                  labelText: 'URL de l\'avatar',
                  prefixIcon: Icon(Icons.image),
                ),
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
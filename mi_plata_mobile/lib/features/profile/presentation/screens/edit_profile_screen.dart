import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = 'Estudiante Universitario';
  File? _imageFile;

  final List<String> _roles = [
    'Estudiante Universitario',
    'Profesional Independiente',
    'Empleado',
    'Emprendedor',
    'Otro'
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(supabaseProvider).auth.currentUser;
    _nameController.text = user?.userMetadata?['name'] as String? ?? 'Usuario';
    // Load existing image if any (delayed to allow context build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final existingPath = ref.read(profileImageProvider);
      if (existingPath != null) {
        setState(() {
          _imageFile = File(existingPath);
        });
      }
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.graphite900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Editar Perfil', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Photo
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.graphite800,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accent, width: 3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: _imageFile != null
                            ? Image.network(_imageFile!.path, fit: BoxFit.cover) // In web, image_picker returns a blob URL which works with Image.network
                            : Center(
                                child: Text(
                                  _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
                                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.textGray400),
                                ),
                              ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.graphite900, width: 3),
                      ),
                      child: const Icon(LucideIcons.camera, size: 16, color: AppColors.graphite900),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Name Input
            const Text('Nombre Completo', style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Tu nombre',
                hintStyle: const TextStyle(color: AppColors.textGray500),
                filled: true,
                fillColor: AppColors.graphite800,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
              onChanged: (val) => setState(() {}), // To update monogram
            ),
            const SizedBox(height: 24),

            // Role Input
            const Text('Ocupación / Rol', style: TextStyle(color: AppColors.textGray400, fontSize: 12)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.graphite800,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRole,
                  dropdownColor: AppColors.graphite800,
                  icon: const Icon(LucideIcons.chevronDown, color: AppColors.textGray400),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onChanged: (String? newValue) {
                    if (newValue != null) setState(() => _selectedRole = newValue);
                  },
                  items: _roles.map((r) => DropdownMenuItem<String>(
                        value: r,
                        child: Text(r),
                      )).toList(),
                ),
              ),
            ),
            const SizedBox(height: 48),

            ElevatedButton(
              onPressed: () {
                // Save image to provider if it was selected
                if (_imageFile != null) {
                  ref.read(profileImageProvider.notifier).updateProfileImage(_imageFile!.path);
                }
                // Here we would save to Supabase user_metadata for name/role
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Perfil actualizado correctamente'),
                    backgroundColor: AppColors.accent,
                  ),
                );
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.graphite900,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Guardar Cambios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

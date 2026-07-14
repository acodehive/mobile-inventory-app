import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/brand.dart';
import '../providers/brand_providers.dart';

class AddEditBrandScreen extends ConsumerStatefulWidget {
  final Brand? brand;
  const AddEditBrandScreen({super.key, this.brand});

  bool get isEditing => brand != null;

  @override
  ConsumerState<AddEditBrandScreen> createState() => _AddEditBrandScreenState();
}

class _AddEditBrandScreenState extends ConsumerState<AddEditBrandScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String? _logoPath;
  Color _selectedColor = AppColors.electricBlue;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.brand?.name ?? '');
    _logoPath = widget.brand?.logoPath;
    _selectedColor = widget.brand?.colorValue != null
        ? Color(widget.brand!.colorValue!)
        : AppColors.categoryAccents[(widget.brand?.name.hashCode ?? 0) % AppColors.categoryAccents.length];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);
    if (picked != null) {
      setState(() => _logoPath = picked.path);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final notifier = ref.read(brandListProvider.notifier);
    String? error;

    if (widget.isEditing) {
      final updated = widget.brand!.copyWith(
        name: _nameController.text.trim(),
        logoPath: _logoPath,
        colorValue: _selectedColor.value,
      );
      error = await notifier.updateBrand(updated);
    } else {
      error = await notifier.addBrand(
        name: _nameController.text.trim(),
        logoPath: _logoPath,
        colorValue: _selectedColor.value,
      );
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? AppStrings.editBrand : AppStrings.addBrand),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.md),
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickLogo,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: _selectedColor.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                      border: Border.all(color: _selectedColor.withOpacity(0.3), width: 1.5),
                    ),
                    child: _logoPath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                            child: Image.file(File(_logoPath!), fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined, color: _selectedColor),
                              const SizedBox(height: 4),
                              Text('Logo', style: theme.textTheme.bodySmall?.copyWith(color: _selectedColor)),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.lg),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Brand Name', hintText: 'e.g. Apple'),
                validator: (value) => Validators.required(value, field: 'Brand name'),
              ),
              const SizedBox(height: AppDimens.lg),
              Text('Brand Color', style: theme.textTheme.titleSmall),
              const SizedBox(height: AppDimens.sm),
              Wrap(
                spacing: AppDimens.sm,
                runSpacing: AppDimens.sm,
                children: [
                  ...AppColors.categoryAccents,
                  AppColors.success,
                  AppColors.warning,
                  AppColors.danger,
                ].map((color) {
                  final isSelected = color.value == _selectedColor.value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: theme.colorScheme.onSurface, width: 2.5) : null,
                      ),
                      child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 20) : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimens.xl),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(AppStrings.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

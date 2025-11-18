// lib/presentation/screens/profile/edit_profile_screen.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:tour_fe/core/constants/color.dart';
import 'package:tour_fe/data/models/profile_model.dart';
import 'package:tour_fe/services/profile_service.dart';
import 'package:tour_fe/services/token_service.dart';
import 'package:tour_fe/presentation/widgets/TextField.dart';

import '../../../core/utils/Validators.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();
  final TokenService _tokenService = TokenService();

  XFile? _avatar;
  XFile? _coverImage;
  Uint8List? _avatarBytes;
  Uint8List? _coverImageBytes;
  String? _avatarUrl;
  String? _coverImageUrl;

  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();
  final _citizenIdController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _dob;

  bool _isLoading = false;
  late Future<ProfileModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _getProfile();
  }

  Future<ProfileModel> _getProfile() async {
    final token = await _tokenService.getToken();
    final profile = await _profileService.getProfile(token!);

    _userNameController.text = profile.userName ?? '';
    _phoneController.text = profile.phone ?? '';
    _dobController.text = profile.dob ?? '';
    if (profile.dob != null && profile.dob!.isNotEmpty) {
      _dob = DateTime.tryParse(profile.dob!);
    }
    _bioController.text = profile.bio ?? '';
    _citizenIdController.text = profile.citizenId ?? '';
    _addressController.text = profile.address ?? '';

    _avatarUrl = profile.avatar;
    _coverImageUrl = profile.background;

    return profile;
  }

  Future<void> _pickImage({required bool isCover}) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        if (isCover) {
          _coverImage = pickedFile;
          _coverImageBytes = bytes;
        } else {
          _avatar = pickedFile;
          _avatarBytes = bytes;
        }
      });
    }
  }

  ImageProvider<Object>? _getAvatarImageProvider() {
    if (_avatarBytes != null) return MemoryImage(_avatarBytes!);
    if (_avatarUrl != null) return NetworkImage(_avatarUrl!);
    return null;
  }

  Future<void> _saveProfile() async {
    // Chỉ validate khi bấm SAVE
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final token = await _tokenService.getToken();

      final data = {
        'user_name': _userNameController.text,
        'phone': _phoneController.text,
        'dob': _dobController.text,
        'bio': _bioController.text,
        'citizen_id': _citizenIdController.text,
        'address': _addressController.text,
      };

      await _profileService.updateProfile(token!, data, _avatar, _coverImage);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goBack() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<ProfileModel>(
          future: _profileFuture,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snap.hasData) return const Center(child: Text("No data"));

            return _buildProfileForm();
          },
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  _buildCoverAndAvatar(),
                  const SizedBox(height: 40),
                  _buildFormFields(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _isLoading ? null : _goBack,
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          const Expanded(
            child: Text(
              'Edit Profile',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save', style: TextStyle(color: iosBlue)),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverAndAvatar() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: _coverImageBytes != null
                  ? DecorationImage(
                      image: MemoryImage(_coverImageBytes!), fit: BoxFit.cover)
                  : _coverImageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(_coverImageUrl!),
                          fit: BoxFit.cover)
                      : const DecorationImage(
                          image: AssetImage('assets/anhbia.jpg'),
                          fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 66,
            right: 16,
            child: GestureDetector(
              onTap: () => _pickImage(isCover: true),
              child: _cameraButton(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: iosPink,
                    backgroundImage: _getAvatarImageProvider(),
                    child: (_avatarBytes == null && _avatarUrl == null)
                        ? Image.asset('assets/illustration.png',
                            width: 100, height: 100)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _pickImage(isCover: false),
                      child: _cameraButton(size: 16, padding: 6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cameraButton({double size = 20, double padding = 8}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
        ],
      ),
      child: Icon(Icons.camera_alt, color: iosBlue, size: size),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomTextField(
          controller: _userNameController,
          label: "Full Name",
          validator: (v) => Validators.required(v, "Nhập tên"),
        ),
        CustomTextField(
          controller: _phoneController,
          label: "Phone Number",
          validator: Validators.phone,
          keyboardType: TextInputType.phone,
        ),
        CustomTextField(
          controller: _dobController,
          label: "Date of Birth",
          readOnly: true,
          validator: Validators.dob,
          onTap: () async {
            final values = await showCalendarDatePicker2Dialog(
              context: context,
              config: CalendarDatePicker2WithActionButtonsConfig(),
              dialogSize: const Size(325, 400),
              value: _dob != null ? [_dob] : [],
            );

            if (values != null && values.isNotEmpty) {
              setState(() {
                _dob = values[0];
                _dobController.text = _dob!.toString().split(' ')[0];
              });
            }
          },
        ),
        CustomTextField(
          controller: _bioController,
          label: "Bio",
          maxLines: 2,
          validator: Validators.bio,
        ),
        CustomTextField(
          controller: _citizenIdController,
          label: "Citizen ID",
          validator: Validators.citizenId,
        ),
        CustomTextField(
          controller: _addressController,
          label: "Address",
          maxLines: 2,
          validator: Validators.address,
        ),
      ],
    );
  }
}

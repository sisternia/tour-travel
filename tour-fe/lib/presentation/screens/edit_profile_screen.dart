import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:tour_fe/core/constants/color.dart';
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/services/profile_service.dart';
import 'package:tour_fe/services/token_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

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
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _getProfile();
  }

  Future<Map<String, dynamic>> _getProfile() async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final profile = await _profileService.getProfile(token);
      
      _userNameController.text = profile['user_name'] ?? '';
      _phoneController.text = profile['phone'] ?? '';
      _dobController.text = profile['dob'] ?? '';
      if (profile['dob'] != null && profile['dob'].isNotEmpty) {
        _dob = DateTime.parse(profile['dob']);
      }
      _bioController.text = profile['bio'] ?? '';
      _citizenIdController.text = profile['citizen_id'] ?? '';
      _addressController.text = profile['address'] ?? '';
      
      final avatarPath = profile['avatar'];
      if (avatarPath != null) {
        _avatarUrl = ApiConstants.baseServerUrl + (avatarPath as String).replaceFirst('/uploads/', '/assets/');
      } else {
        _avatarUrl = null;
      }

      final backgroundPath = profile['background'];
      if (backgroundPath != null) {
        _coverImageUrl = ApiConstants.baseServerUrl + (backgroundPath as String).replaceFirst('/uploads/', '/assets/');
      } else {
        _coverImageUrl = null;
      }
      
      return profile;
    } catch (e) {
      debugPrint('Failed to load profile: ${e.toString()}');
      rethrow;
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _bioController.dispose();
    _citizenIdController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool isCover}) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
    if (_avatarBytes != null) {
      return MemoryImage(_avatarBytes!);
    } else if (_avatarUrl != null) {
      return NetworkImage(_avatarUrl!);
    }
    return null;
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final token = await _tokenService.getToken();
        if (token == null) {
          throw Exception('Token not found');
        }
        
        Map<String, String> data = {
          'user_name': _userNameController.text,
          'phone': _phoneController.text,
          'dob': _dobController.text,
          'bio': _bioController.text,
          'citizen_id': _citizenIdController.text,
          'address': _addressController.text,
        };

        await _profileService.updateProfile(token, data, _avatar, _coverImage);
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Failed to load profile: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _profileFuture = _getProfile();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildCoverAndAvatar(),
                            const SizedBox(height: 50),
                            _buildFormFields(),
                            const SizedBox(height: 8),
                        ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No profile data.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(iosBlue),
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: iosBlue,
                    ),
                  ),
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
          // Cover Image
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: (_coverImageBytes != null || _coverImageUrl != null)
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        iosBlue.withOpacity(0.8),
                        iosBlue.withOpacity(0.6),
                      ],
                    ),
              image: _coverImageBytes != null
                  ? DecorationImage(
                      image: MemoryImage(_coverImageBytes!),
                      fit: BoxFit.cover,
                    )
                  : _coverImageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(_coverImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
            ),
            child: (_coverImageBytes == null && _coverImageUrl == null)
                ? Image.asset(
                    'assets/anhbia.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  )
                : null,
          ),
          // Camera button for cover image
          Positioned(
            bottom: 66, // 200 - 150 (cover image height) + 16
            right: 16,
            child: GestureDetector(
              onTap: () => _pickImage(isCover: true),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: iosBlue,
                  size: 20,
                ),
              ),
            ),
          ),
          // Avatar positioned over cover
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: iosPink,
                      backgroundImage: _getAvatarImageProvider(),
                      child: (_avatarBytes == null && _avatarUrl == null)
                          ? Image.asset(
                              'assets/illustration.png',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )
                          : null,
                    ),
                    // Camera button for avatar
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _pickImage(isCover: false),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: iosBlue, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: iosBlue,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _userNameController,
          labelText: 'Full Name',
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _phoneController,
          labelText: 'Phone Number',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 8),
        _buildDatePicker(),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _bioController,
          labelText: 'Bio',
          icon: Icons.info,
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _citizenIdController,
          labelText: 'Citizen ID',
          icon: Icons.credit_card,
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _addressController,
          labelText: 'Address',
          icon: Icons.location_on,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: iosGray),
        filled: true,
        fillColor: iosLightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        prefixIcon: const Icon(Icons.calendar_today, color: iosGray),
        filled: true,
        fillColor: iosLightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      onTap: () async {
        final values = await showCalendarDatePicker2Dialog(
          context: context,
          config: CalendarDatePicker2WithActionButtonsConfig(
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          ),
          value: _dob != null ? [_dob] : [],
          dialogSize: const Size(325, 400),
        );

        if (values != null && values.isNotEmpty) {
          setState(() {
            _dob = values[0];
            _dobController.text = _dob!.toLocal().toString().split(' ')[0];
          });
        }
      },
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _goBack,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Quay lại',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: iosBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Lưu thay đổi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

}
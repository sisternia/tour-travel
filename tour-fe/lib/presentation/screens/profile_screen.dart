// lib/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/core/constants/color.dart';
import 'package:tour_fe/data/models/profile_model.dart';
import 'package:tour_fe/presentation/screens/edit_profile_screen.dart';
import 'package:tour_fe/services/profile_service.dart';
import 'package:tour_fe/services/token_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final TokenService _tokenService = TokenService();
  late Future<ProfileModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _getProfile();
  }

  Future<ProfileModel> _getProfile() async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) throw Exception('Token not found');
      return await _profileService.getProfile(token);
    } catch (e) {
      debugPrint('Failed to load profile: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<ProfileModel>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return _buildError(snapshot.error.toString());
            } else if (snapshot.hasData) {
              final profile = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCoverAvatarAndInfo(context, profile),
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: _buildInfoFields(profile),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No profile data.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Failed to load profile: $message'),
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
  }

  Widget _buildCoverAvatarAndInfo(BuildContext context, ProfileModel profile) {
    final String? backgroundPath = profile.background;
    final String? avatarPath = profile.avatar;

    final String? backgroundImage = backgroundPath != null
        ? '${ApiConstants.baseServerUrl}${backgroundPath.replaceFirst('/uploads/', '/assets/')}'
        : null;
    final String? avatarImage = avatarPath != null
        ? '${ApiConstants.baseServerUrl}${avatarPath.replaceFirst('/uploads/', '/assets/')}'
        : null;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Cover Image
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: backgroundImage == null
                ? LinearGradient(
                    colors: [
                      iosBlue.withOpacity(0.8),
                      iosBlue.withOpacity(0.6)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            image: backgroundImage != null
                ? DecorationImage(
                    image: NetworkImage(backgroundImage), fit: BoxFit.cover)
                : const DecorationImage(
                    image: AssetImage('assets/anhbia.jpg'), fit: BoxFit.cover),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfileScreen()),
                  ).then((_) => setState(() => _profileFuture = _getProfile()));
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.edit, color: iosBlue, size: 20),
                ),
              ),
            ),
          ),
        ),

        // Avatar
        Positioned(
          top: 120,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: iosPink,
              backgroundImage:
                  avatarImage != null ? NetworkImage(avatarImage) : null,
              child: avatarImage == null
                  ? ClipOval(
                      child: Image.asset('assets/illustration.png',
                          fit: BoxFit.cover, width: 100, height: 100),
                    )
                  : null,
            ),
          ),
        ),

        // User Info
        Positioned(
          top: 230,
          child: Column(
            children: [
              Text(profile.userName ?? 'User',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 4),
              Text(profile.email ?? 'example@example.com',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoFields(ProfileModel profile) {
    final infoItems = [
      _InfoItem(Icons.person, 'Full Name', profile.userName ?? 'Not set'),
      _InfoItem(Icons.phone, 'Phone Number', profile.phone ?? 'Not set'),
      _InfoItem(
          Icons.calendar_today, 'Date of Birth', profile.dob ?? 'Not set'),
      _InfoItem(Icons.info, 'Bio', profile.bio ?? 'Not set'),
      _InfoItem(
          Icons.credit_card, 'Citizen ID', profile.citizenId ?? 'Not set'),
      _InfoItem(Icons.location_on, 'Address', profile.address ?? 'Not set'),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: infoItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == infoItems.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: iosGray),
                title: Text(item.label,
                    style: const TextStyle(
                        fontSize: 12,
                        color: iosGray,
                        fontWeight: FontWeight.w500)),
                subtitle: Text(
                  item.value.isNotEmpty ? item.value : 'Not set',
                  style: TextStyle(
                      fontSize: 14,
                      color: item.value == 'Not set' ? iosGray : Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              ),
              if (!isLast)
                Divider(height: 1, color: Colors.grey.shade200, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  _InfoItem(this.icon, this.label, this.value);
}

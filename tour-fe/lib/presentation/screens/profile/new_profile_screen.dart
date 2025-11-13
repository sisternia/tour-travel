// lib\presentation\screens\profile\new_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:tour_fe/core/constants/api.dart';
import 'package:tour_fe/data/models/profile_model.dart';
import 'package:tour_fe/presentation/screens/profile/edit_profile_screen.dart';
import 'package:tour_fe/services/profile_service.dart';
import 'package:tour_fe/services/token_service.dart';

class NewProfileScreen extends StatefulWidget {
  const NewProfileScreen({super.key});

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
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
      final profile = await _profileService.getProfile(token);
      return profile;
    } catch (e) {
      debugPrint('Failed to load profile: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<ProfileModel>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load profile: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final profile = snapshot.data!;
            return _buildProfileContent(profile);
          } else {
            return const Center(child: Text('No profile data.'));
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(ProfileModel profile) {
    final avatarUrl = profile.avatar != null && profile.avatar!.isNotEmpty
        ? ApiConstants.baseServerUrl + profile.avatar!
        : 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y';

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/anhbia.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 140,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 58,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 70),
          Text(
            profile.userName ?? profile.userId ?? 'N/A',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            profile.email ?? 'N/A',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildInfoCard(profile),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildFunctionalList(profile),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ProfileModel profile) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.phone, 'Phone number', profile.phone ?? 'N/A'),
            const Divider(),
            _buildInfoRow(
                Icons.calendar_today, 'Date of birth', profile.dob ?? 'N/A'),
            const Divider(),
            _buildInfoRow(
                Icons.credit_card, 'Citizen ID', profile.citizenId ?? 'N/A'),
            const Divider(),
            _buildInfoRow(Icons.home, 'Address', profile.address ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionalList(ProfileModel profile) {
    return Column(
      children: [
        _buildFunctionalListItem(
            Icons.person_outline, 'Bio / About', profile.bio ?? 'N/A'),
        const Divider(),
        _buildFunctionalListItem(Icons.settings, 'Settings', ''),
        const Divider(),
        _buildFunctionalListItem(Icons.info_outline, 'App version', '1.0.0'),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildFunctionalListItem(
      IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}

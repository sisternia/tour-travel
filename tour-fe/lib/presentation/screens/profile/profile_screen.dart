// lib/presentation/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:tour_fe/core/constants/color.dart';
import 'package:tour_fe/data/models/profile_model.dart';
import 'package:tour_fe/presentation/screens/profile/edit_profile_screen.dart';
import 'package:tour_fe/services/profile_service.dart';
import 'package:tour_fe/services/token_service.dart';
import 'package:tour_fe/services/post_service.dart';

String _formatDate(String? dateString) {
  if (dateString == null || dateString.isEmpty || dateString == 'Not set') {
    return 'Not set';
  }

  try {
    final date = DateTime.parse(dateString);
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  } catch (e) {
    return dateString;
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  final ProfileService _profileService = ProfileService();
  final TokenService _tokenService = TokenService();
  final PostService _postService = PostService();

  late Future<ProfileModel> _profileFuture;
  List<Map<String, dynamic>> posts = [];
  bool isLoadingPosts = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _profileFuture = _getProfile();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    if (!mounted) return;
    setState(() => isLoadingPosts = true);
    try {
      final profile = await _profileFuture;
      final list = await _postService.getPostsByUserId(profile.userId ?? "");

      if (!mounted) return;
      setState(() {
        posts = list.map<Map<String, dynamic>>((item) {
          return {
            "postId": item["post_id"],
            "userId": item["user_id"],
            "userName": item["user_name"] ?? "Người dùng",
            "userAvatar": item["avatar"],
            "content": item["content"],
            "privacy": item["privacy"],
            "createdAt": DateTime.parse(item["created_at"]),
            "sharedFromPostId": item["shared_from_post_id"],
            "sharedFromUserId": item["shared_from_user_id"],
            "sharedFromUserName": item["shared_from_user_name"],
            "sharedFromUserAvatar": item["shared_from_user_avatar"],
            "sharedNote": item["shared_note"],
            "images": (item["images"] ?? []).map<Map<String, dynamic>>((img) {
              return {
                "url": img["image_url"],
                "bytes": null,
                "isVertical": false,
              };
            }).toList(),
          };
        }).toList();
        isLoadingPosts = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingPosts = false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshProfile();
    }
  }

  Future<ProfileModel> _getProfile() async {
    final token = await _tokenService.getToken();
    return await _profileService.getProfile(token!);
  }

  void refreshProfile() {
    if (mounted) {
      setState(() {
        _profileFuture = _getProfile();
      });
    }
  }

  void _refreshProfile() {
    refreshProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
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
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          const Expanded(
            child: Text(
              'Profile',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 40),
        ],
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
            onPressed: () => setState(() => _profileFuture = _getProfile()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverAvatarAndInfo(BuildContext context, ProfileModel profile) {
    final backgroundImage = profile.background;
    final avatarImage = profile.avatar;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            image: (backgroundImage != null && backgroundImage.isNotEmpty)
                ? DecorationImage(
                    image: NetworkImage(backgroundImage),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: (backgroundImage == null || backgroundImage.isEmpty)
              ? const Center(
                  child:
                      Icon(Icons.image_outlined, size: 60, color: Colors.white),
                )
              : null,
        ),
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
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: iosPink,
              backgroundImage: (avatarImage != null && avatarImage.isNotEmpty)
                  ? NetworkImage(avatarImage)
                  : null,
              child: (avatarImage == null || avatarImage.isEmpty)
                  ? const Icon(Icons.person_outline,
                      size: 60, color: Colors.white)
                  : null,
            ),
          ),
        ),
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
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
              if (result == true) _refreshProfile();
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
      ],
    );
  }

  Widget _buildInfoFields(ProfileModel profile) {
    final infoItems = [
      _InfoItem(Icons.person, 'Full Name', profile.userName ?? 'Not set'),
      _InfoItem(Icons.phone, 'Phone Number', profile.phone ?? 'Not set'),
      _InfoItem(
          Icons.calendar_today, 'Date of Birth', _formatDate(profile.dob)),
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
        children: [
          ...infoItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

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
                    item.value,
                    style: TextStyle(
                      fontSize: 14,
                      color: item.value == 'Not set' ? iosGray : Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                ),
                if (index != infoItems.length - 1)
                  Divider(height: 1, color: Colors.grey.shade200, indent: 56),
              ],
            );
          }),
        ],
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

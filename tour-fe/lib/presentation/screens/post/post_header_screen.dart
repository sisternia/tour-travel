// lib/presentation/screens/post/post_header_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tour_fe/core/constants/color.dart';
import 'package:tour_fe/data/models/profile_model.dart';
import 'package:tour_fe/services/profile_service.dart';
import 'package:tour_fe/services/token_service.dart';
import 'package:tour_fe/services/post_service.dart';
import 'package:tour_fe/services/post_reaction_service.dart';
import 'package:tour_fe/services/post_comment_service.dart';
import 'package:tour_fe/services/post_share_service.dart';
import 'post_modal_screen.dart';
import '../../widgets/Post_Shows.dart';
import '../profile/profile_screen.dart';
import '../profile/edit_profile_screen.dart';
import 'package:tour_fe/presentation/widgets/Button.dart';
import '../auth/login_screen.dart';
import 'package:ionicons/ionicons.dart';

class PostHeaderScreen extends StatefulWidget {
  const PostHeaderScreen({super.key});

  @override
  State<PostHeaderScreen> createState() => _PostHeaderScreenState();
}

class _PostHeaderScreenState extends State<PostHeaderScreen> {
  final ProfileService _profileService = ProfileService();
  final TokenService _tokenService = TokenService();
  final PostService _postService = PostService();
  final PostReactionService _reactionService = PostReactionService();
  final PostCommentService _commentService = PostCommentService();
  final PostShareService _shareService = PostShareService();

  late Future<ProfileModel> _profileFuture;
  String? currentUserId;

  List<Map<String, dynamic>> posts = [];
  int? editingIndex;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _profileFuture = _getProfile();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final profile = await _profileFuture;
      currentUserId = profile.userId;
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
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<ProfileModel> _getProfile() async {
    final token = await _tokenService.getToken();
    return await _profileService.getProfile(token!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<ProfileModel>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final profile = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(profile),
                  const SizedBox(height: 120),
                  _buildButtons(context),
                  const SizedBox(height: 20),
                  _buildDivider(),
                  const SizedBox(height: 10),
                  _buildFloatingCard(profile),
                  const SizedBox(height: 20),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    )
                  else
                    ...posts.asMap().entries.map((p) {
                      return PostShows(
                        postId: p.value["postId"],
                        userId: p.value["userId"],
                        userName: p.value["userName"],
                        userAvatar: p.value["userAvatar"],
                        currentUserId: currentUserId ?? "",
                        content: p.value["content"],
                        images: p.value["images"],
                        createdAt: p.value["createdAt"],
                        privacy: p.value["privacy"],
                        sharedNote: p.value["sharedNote"],
                        sharedFromUserName: p.value["sharedFromUserName"],
                        sharedFromUserAvatar: p.value["sharedFromUserAvatar"],
                        sharedFromUserId: p.value["sharedFromUserId"],
                        onDelete: () async {
                          await _postService.deletePost(
                            postId: p.value["postId"],
                            userName: profile.userName ?? "",
                          );
                          _loadPosts();
                        },
                        onEdit: () {
                          editingIndex = p.key;
                          _openEditPostModal(profile, posts[p.key]);
                        },
                        onReaction: (reactionType) async {
                          if (currentUserId == null) return;
                          final existing =
                              await _reactionService.getUserReaction(
                            currentUserId!,
                            p.value["postId"],
                          );
                          if (existing != null) {
                            if (existing["reaction_type"] == reactionType) {
                              await _reactionService.removeReaction(
                                postId: p.value["postId"],
                                userId: currentUserId!,
                              );
                            } else {
                              await _reactionService.addReaction(
                                postId: p.value["postId"],
                                userId: currentUserId!,
                                reactionType: reactionType,
                              );
                            }
                          } else {
                            await _reactionService.addReaction(
                              postId: p.value["postId"],
                              userId: currentUserId!,
                              reactionType: reactionType,
                            );
                          }
                          _loadPosts();
                        },
                        onComment: (content) async {
                          if (currentUserId == null) return;
                          await _commentService.addComment(
                            postId: p.value["postId"],
                            userId: currentUserId!,
                            content: content,
                          );
                          _loadPosts();
                        },
                        onShare: () async {
                          if (currentUserId == null) return;
                          final originalUserId =
                              p.value["sharedFromUserId"] ?? p.value["userId"];
                          await _shareService.sharePost(
                            postId: p.value["postId"],
                            userId: currentUserId!,
                            sharedFromUserId: originalUserId,
                          );
                          _loadPosts();
                        },
                      );
                    }),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ProfileModel profile) {
    final background = profile.background;
    final avatar = profile.avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: background == null
                ? LinearGradient(
                    colors: [
                      iosBlue.withOpacity(0.8),
                      iosBlue.withOpacity(0.6)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            image: background != null
                ? DecorationImage(
                    image: NetworkImage(background),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: AssetImage("assets/anhbia.jpg"),
                    fit: BoxFit.cover,
                  ),
          ),
        ),

        // LOGOUT BUTTON (TOP RIGHT)
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: _handleLogout,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Ionicons.log_out_outline,
                color: Colors.redAccent,
                size: 22,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: -40,
          left: 0,
          right: 0,
          child: Center(
            child: CircleAvatar(
              radius: 52,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 48,
                backgroundColor: iosPink,
                backgroundImage: avatar != null ? NetworkImage(avatar) : null,
                child: avatar == null
                    ? Image.asset("assets/illustration.png")
                    : null,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -110,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(profile.userName ?? "User",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(profile.email ?? "",
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn đăng xuất?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await _tokenService.deleteToken();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info, color: Colors.white),
                  SizedBox(width: 6),
                  Text("Xem thông tin",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()));
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryButton(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: Colors.white),
                  SizedBox(width: 6),
                  Text("Sửa thông tin",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildFloatingCard(ProfileModel profile) {
    final avatar = profile.avatar;

    return GestureDetector(
      onTap: () {
        editingIndex = null;
        _openCreatePostModal(profile);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        avatar != null ? NetworkImage(avatar) : null,
                    child: avatar == null
                        ? Image.asset("assets/illustration.png")
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Bạn đang nghĩ gì?",
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: 1, width: double.infinity, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mediaButton(Icons.videocam, Colors.red, "Video trực tiếp"),
                  _mediaButton(Icons.image, Colors.green, "Ảnh/video"),
                  _mediaButton(Icons.flag, Colors.blue, "Cột mốc"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mediaButton(IconData icon, Color color, String label) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _openCreatePostModal(ProfileModel profile) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Post',
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, a1, _, __) {
        final curved = Curves.easeOut.transform(a1.value);
        return Opacity(
          opacity: a1.value,
          child: Transform.scale(
            scale: 0.96 + 0.04 * curved,
            child: Center(
              child: PostModal(
                profile: profile,
                onPost: (content, images, privacy) async {
                  if (content.isEmpty && images.isEmpty) return;
                  final bytesList = <Uint8List>[];
                  for (var img in images) {
                    if (img['bytes'] is Uint8List) {
                      bytesList.add(img['bytes']);
                    }
                  }
                  final res = await _postService.createPost(
                    userId: profile.userId ?? "",
                    userName: profile.userName ?? "",
                    content: content,
                    privacy: privacy,
                    images: bytesList,
                  );
                  if (res["success"] == true) {
                    await _loadPosts();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _openEditPostModal(ProfileModel profile, Map<String, dynamic> post) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Edit',
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, a1, _, __) {
        final curved = Curves.easeOut.transform(a1.value);
        return Opacity(
          opacity: a1.value,
          child: Transform.scale(
            scale: 0.95 + 0.05 * curved,
            child: Center(
              child: PostModal(
                profile: profile,
                initialContent: post["content"],
                initialImages: post["images"],
                initialPrivacy: post["privacy"],
                onPost: (content, images, privacy) async {
                  final bytesList = <Uint8List>[];
                  for (var img in images) {
                    if (img["bytes"] != null) bytesList.add(img["bytes"]);
                  }
                  final ok = await _postService.updatePost(
                    postId: post["postId"],
                    userName: profile.userName ?? "",
                    content: content,
                    privacy: privacy,
                    imagesBytes: bytesList,
                  );
                  if (ok) await _loadPosts();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

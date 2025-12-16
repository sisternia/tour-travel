// lib/presentation/screens/post/social_feed_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tour_fe/data/models/profile_model.dart';
import 'package:tour_fe/services/profile_service.dart';
import 'package:tour_fe/services/token_service.dart';
import 'package:tour_fe/services/post_service.dart';
import 'package:tour_fe/services/post_reaction_service.dart';
import 'package:tour_fe/services/post_comment_service.dart';
import 'package:tour_fe/services/post_share_service.dart';
import 'post_modal_screen.dart';
import '../../widgets/Post_Shows.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final ProfileService _profileService = ProfileService();
  final TokenService _tokenService = TokenService();
  final PostService _postService = PostService();
  final PostReactionService _reactionService = PostReactionService();
  final PostCommentService _commentService = PostCommentService();
  final PostShareService _shareService = PostShareService();

  late Future<ProfileModel> _profileFuture;
  String? currentUserId;

  List<Map<String, dynamic>> posts = [];
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
      final list = await _postService.getPosts();
      final profile = await _profileFuture;
      currentUserId = profile.userId;

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
      appBar: AppBar(
        title: const Text(
          "Mạng xã hội",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<ProfileModel>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final profile = snapshot.data!;

            return RefreshIndicator(
              onRefresh: _loadPosts,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildFloatingCard(profile),
                    const SizedBox(height: 10),
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      )
                    else
                      ...posts.asMap().entries.map((p) {
                        final post = p.value;
                        final isOwner = post["userId"] == currentUserId;
                        return PostShows(
                          postId: post["postId"],
                          userId: post["userId"],
                          userName: post["userName"],
                          userAvatar: post["userAvatar"],
                          currentUserId: currentUserId ?? "",
                          content: post["content"],
                          images: post["images"],
                          createdAt: post["createdAt"],
                          privacy: post["privacy"],
                          sharedNote: post["sharedNote"],
                          sharedFromUserName: post["sharedFromUserName"],
                          sharedFromUserAvatar: post["sharedFromUserAvatar"],
                          sharedFromUserId: post["sharedFromUserId"],
                          onDelete: isOwner
                              ? () async {
                                  await _postService.deletePost(
                                    postId: post["postId"],
                                    userName: profile.userName ?? "",
                                  );
                                  _loadPosts();
                                }
                              : null,
                          onEdit: isOwner
                              ? () {
                                  // Edit functionality
                                }
                              : null,
                          onReaction: (reactionType) async {
                            if (currentUserId == null) return;
                            final existing =
                                await _reactionService.getUserReaction(
                              currentUserId!,
                              post["postId"],
                            );
                            if (existing != null) {
                              if (existing["reaction_type"] == reactionType) {
                                await _reactionService.removeReaction(
                                  postId: post["postId"],
                                  userId: currentUserId!,
                                );
                              } else {
                                await _reactionService.addReaction(
                                  postId: post["postId"],
                                  userId: currentUserId!,
                                  reactionType: reactionType,
                                );
                              }
                            } else {
                              await _reactionService.addReaction(
                                postId: post["postId"],
                                userId: currentUserId!,
                                reactionType: reactionType,
                              );
                            }
                            _loadPosts();
                          },
                          onComment: (content) async {
                            if (currentUserId == null) return;
                            await _commentService.addComment(
                              postId: post["postId"],
                              userId: currentUserId!,
                              content: content,
                            );
                            _loadPosts();
                          },
                          onShare: () async {
                            if (currentUserId == null) return;
                            // If this post is already a share, use the original user ID
                            final originalUserId =
                                post["sharedFromUserId"] ?? post["userId"];
                            await _shareService.sharePost(
                              postId: post["postId"],
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
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFloatingCard(ProfileModel profile) {
    final avatar = profile.avatar;

    return GestureDetector(
      onTap: () {
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
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, a1, a2, child) {
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
}

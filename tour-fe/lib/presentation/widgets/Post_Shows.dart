// lib/presentation/widgets/Post_Shows.dart

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_fe/presentation/widgets/Image_Post.dart';
import 'package:tour_fe/services/post_reaction_service.dart';
import 'package:tour_fe/services/post_comment_service.dart';
import 'package:tour_fe/services/post_share_service.dart';

class PostShows extends StatefulWidget {
  final String postId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String currentUserId;
  final String content;
  final DateTime createdAt;
  final String? privacy;
  final List<Map<String, dynamic>>? images;
  final Uint8List? videoBytes;
  final String? sharedNote;
  final String? sharedFromUserName;
  final String? sharedFromUserAvatar;
  final String? sharedFromUserId;

  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final Function(String)? onReaction;
  final Function(String)? onComment;
  final VoidCallback? onShare;

  const PostShows({
    super.key,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.currentUserId,
    required this.content,
    required this.createdAt,
    this.privacy = "public",
    this.images,
    this.videoBytes,
    this.sharedNote,
    this.sharedFromUserName,
    this.sharedFromUserAvatar,
    this.sharedFromUserId,
    this.onDelete,
    this.onEdit,
    this.onReaction,
    this.onComment,
    this.onShare,
  });

  @override
  State<PostShows> createState() => _PostShowsState();
}

class _PostShowsState extends State<PostShows> {
  final PostReactionService _reactionService = PostReactionService();
  final PostCommentService _commentService = PostCommentService();
  final PostShareService _shareService = PostShareService();

  Map<String, int> reactionCounts = {};
  Map<String, dynamic>? userReaction;
  int commentCount = 0;
  int shareCount = 0;
  bool showComments = false;
  List<dynamic> comments = [];
  bool isLoadingReactions = false;
  bool isLoadingComments = false;
  final TextEditingController _commentController = TextEditingController();

  // Double tap detection for reactions
  DateTime? _lastTap;
  Timer? _singleTapTimer;
  static const Duration _doubleTapDelay = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _loadReactions();
    _loadCommentCount();
    _loadShareCount();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _singleTapTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadReactions() async {
    if (!mounted) return;
    setState(() => isLoadingReactions = true);
    try {
      final data = await _reactionService.getReactions(widget.postId);
      Map<String, dynamic>? userReact;
      if (widget.currentUserId.isNotEmpty) {
        userReact = await _reactionService.getUserReaction(
          widget.currentUserId,
          widget.postId,
        );
      }
      if (!mounted) return;
      setState(() {
        reactionCounts = Map<String, int>.from(data["counts"] ?? {});
        userReaction = userReact;
        isLoadingReactions = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingReactions = false);
    }
  }

  Future<void> _loadCommentCount() async {
    try {
      final count = await _commentService.getCommentCount(widget.postId);
      if (!mounted) return;
      setState(() => commentCount = count);
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _loadShareCount() async {
    try {
      final count = await _shareService.getShareCount(widget.postId);
      if (!mounted) return;
      setState(() => shareCount = count);
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _loadComments() async {
    if (!mounted) return;
    setState(() => isLoadingComments = true);
    try {
      final list = await _commentService.getComments(widget.postId);
      if (!mounted) return;
      setState(() {
        comments = list;
        isLoadingComments = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingComments = false);
    }
  }

  void _toggleComments() {
    setState(() {
      showComments = !showComments;
      if (showComments && comments.isEmpty) {
        _loadComments();
      }
    });
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;
    final content = _commentController.text.trim();
    if (widget.onComment != null) {
      widget.onComment!(content);
      _commentController.clear();

      // Add comment immediately to UI
      if (showComments && mounted) {
        setState(() {
          comments.add({
            "user_id": widget.currentUserId,
            "user_name": "Bạn", // Will be updated when reloaded
            "avatar": null,
            "content": content,
            "created_at": DateTime.now().toIso8601String(),
          });
        });
      }

      if (!mounted) return;
      _loadCommentCount();

      // Reload comments to get the actual data from server
      if (showComments) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) _loadComments();
      }
    }
  }

  String _getShareNoteText() {
    if (widget.sharedFromUserName == null) return widget.sharedNote ?? "";

    final sharerName = widget.userName;
    final originalPostOwnerName = widget.sharedFromUserName!;

    // Nếu người đang xem là người chia sẻ
    if (widget.currentUserId == widget.userId) {
      return "Bạn đã chia sẻ bài viết của $originalPostOwnerName";
    }
    // Nếu người đang xem là người đăng bài gốc
    else if (widget.sharedFromUserId != null &&
        widget.currentUserId == widget.sharedFromUserId) {
      return "$sharerName đã chia sẻ bài viết của bạn";
    }
    // Nếu người đang xem là người khác
    else {
      return "$sharerName đã chia sẻ bài viết của $originalPostOwnerName";
    }
  }

  String formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return "Vừa xong";
    if (diff.inMinutes < 60) return "${diff.inMinutes} phút";
    if (diff.inHours < 24) return "${diff.inHours} giờ";
    if (diff.inDays < 5) return "${diff.inDays} ngày";

    return DateFormat('dd/MM/yyyy HH:mm').format(time);
  }

  IconData _privacyIcon() {
    switch (widget.privacy) {
      case "public":
        return Icons.public;
      case "friends":
        return Icons.group;
      case "only_me":
        return Icons.lock;
      case "custom":
        return Icons.settings;
    }
    return Icons.public;
  }

  Widget _buildReactionButton(String type, String emoji, Color color) {
    final isActive = userReaction?["reaction_type"] == type;
    final count = reactionCounts[type] ?? 0;

    return GestureDetector(
      onTap: () {
        if (widget.onReaction != null) {
          widget.onReaction!(type);
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) _loadReactions();
          });
        }
      },
      onLongPress: () => _showReactionPicker(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? color : Colors.grey.shade600,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showReactionPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildReactionOption("like", "👍", Colors.blue, "Thích"),
                _buildReactionOption("love", "❤️", Colors.red, "Yêu thích"),
                _buildReactionOption("haha", "😂", Colors.orange, "Haha"),
                _buildReactionOption("wow", "😮", Colors.purple, "Wow"),
                _buildReactionOption("sad", "😢", Colors.blue, "Buồn"),
                _buildReactionOption("angry", "😡", Colors.red, "Phẫn nộ"),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  String _getReactionLabel(String? type) {
    switch (type) {
      case "like":
        return "Thích";
      case "love":
        return "Yêu thích";
      case "haha":
        return "Haha";
      case "wow":
        return "Wow";
      case "sad":
        return "Buồn";
      case "angry":
        return "Phẫn nộ";
      default:
        return "Thích";
    }
  }

  Widget _buildReactionOption(
      String type, String emoji, Color color, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (widget.onReaction != null) {
          widget.onReaction!(type);
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) _loadReactions();
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalReactions = reactionCounts.values.fold(0, (a, b) => a + b);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (widget.sharedNote != null &&
              widget.sharedFromUserName != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.share, size: 16, color: Colors.blue.shade700),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _getShareNoteText(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (widget.sharedFromUserAvatar != null &&
              widget.sharedNote != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(widget.sharedFromUserAvatar!),
                ),
                const SizedBox(width: 6),
                Text(
                  "Bài viết gốc của ${widget.sharedFromUserName ?? "Người dùng"}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          if (widget.content.isNotEmpty)
            Text(widget.content, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          if (widget.images != null && widget.images!.isNotEmpty)
            ImagePost(images: widget.images!),
          const SizedBox(height: 12),
          if (totalReactions > 0 || commentCount > 0 || shareCount > 0) ...[
            Container(height: 1, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  if (totalReactions > 0)
                    Row(
                      children: [
                        // Hiển thị các loại react với số lượng
                        if (reactionCounts["like"] != null &&
                            reactionCounts["like"]! > 0)
                          Row(
                            children: [
                              const Text("👍", style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 2),
                              Text(
                                reactionCounts["like"]!.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        if (reactionCounts["love"] != null &&
                            reactionCounts["love"]! > 0)
                          Row(
                            children: [
                              const Text("❤️", style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 2),
                              Text(
                                reactionCounts["love"]!.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        if (reactionCounts["haha"] != null &&
                            reactionCounts["haha"]! > 0)
                          Row(
                            children: [
                              const Text("😂", style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 2),
                              Text(
                                reactionCounts["haha"]!.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        if (reactionCounts["wow"] != null &&
                            reactionCounts["wow"]! > 0)
                          Row(
                            children: [
                              const Text("😮", style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 2),
                              Text(
                                reactionCounts["wow"]!.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        if (reactionCounts["sad"] != null &&
                            reactionCounts["sad"]! > 0)
                          Row(
                            children: [
                              const Text("😢", style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 2),
                              Text(
                                reactionCounts["sad"]!.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        if (reactionCounts["angry"] != null &&
                            reactionCounts["angry"]! > 0)
                          Row(
                            children: [
                              const Text("😡", style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 2),
                              Text(
                                reactionCounts["angry"]!.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  const Spacer(),
                  if (commentCount > 0)
                    Text(
                      "$commentCount bình luận",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  if (commentCount > 0 && shareCount > 0)
                    Text(" • ", style: TextStyle(color: Colors.grey.shade700)),
                  if (shareCount > 0)
                    Text(
                      "$shareCount chia sẻ",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          _buildActions(),
          if (showComments) ...[
            const SizedBox(height: 12),
            _buildCommentsSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: widget.userAvatar != null
              ? NetworkImage(widget.userAvatar!)
              : null,
          child: widget.userAvatar == null
              ? Image.asset("assets/illustration.png")
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    formatTimeAgo(widget.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 6),
                  Icon(_privacyIcon(), size: 14, color: Colors.grey.shade600),
                ],
              ),
            ],
          ),
        ),
        if (widget.onDelete != null || widget.onEdit != null)
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "delete" && widget.onDelete != null)
                widget.onDelete!();
              if (value == "edit" && widget.onEdit != null) widget.onEdit!();
            },
            itemBuilder: (context) => [
              if (widget.onEdit != null)
                const PopupMenuItem(
                  value: "edit",
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: 8),
                      Text("Chỉnh sửa"),
                    ],
                  ),
                ),
              if (widget.onDelete != null)
                PopupMenuItem(
                  value: "delete",
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20, color: Colors.red),
                      const SizedBox(width: 8),
                      Text("Xóa", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }

  void _handleLikeTap() {
    final now = DateTime.now();

    // Cancel any pending single tap
    _singleTapTimer?.cancel();

    if (_lastTap != null && now.difference(_lastTap!) < _doubleTapDelay) {
      // Double tap detected - show reaction picker
      _lastTap = null;
      _showReactionPicker();
    } else {
      // Single tap - wait to see if it's a double tap
      _lastTap = now;
      _singleTapTimer = Timer(_doubleTapDelay, () {
        // Single tap confirmed after delay
        if (_lastTap == now && mounted) {
          if (widget.onReaction != null) {
            widget.onReaction!("like");
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) _loadReactions();
            });
          }
        }
      });
    }
  }

  Widget _buildActions() {
    final hasReaction = userReaction != null;
    final currentReactionType = userReaction?["reaction_type"];
    final totalReactions =
        reactionCounts.values.fold<int>(0, (sum, count) => sum + count);

    // Get emoji and color based on current reaction
    String reactionEmoji = "👍";
    Color reactionColor = Colors.grey.shade700;

    if (currentReactionType != null) {
      switch (currentReactionType) {
        case "like":
          reactionEmoji = "👍";
          reactionColor = Colors.blue;
          break;
        case "love":
          reactionEmoji = "❤️";
          reactionColor = Colors.red;
          break;
        case "haha":
          reactionEmoji = "😂";
          reactionColor = Colors.orange;
          break;
        case "wow":
          reactionEmoji = "😮";
          reactionColor = Colors.purple;
          break;
        case "sad":
          reactionEmoji = "😢";
          reactionColor = Colors.blue;
          break;
        case "angry":
          reactionEmoji = "😡";
          reactionColor = Colors.red;
          break;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _handleLikeTap,
            onLongPress: () => _showReactionPicker(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    reactionEmoji,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getReactionLabel(currentReactionType),
                    style: TextStyle(
                      fontSize: 14,
                      color: hasReaction ? reactionColor : Colors.grey.shade700,
                      fontWeight:
                          hasReaction ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: _toggleComments,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 20,
                    color: showComments ? Colors.blue : Colors.grey.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Bình luận",
                    style: TextStyle(
                      fontSize: 14,
                      color: showComments ? Colors.blue : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (widget.onShare != null) {
                widget.onShare!();
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) _loadShareCount();
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share_outlined,
                      size: 20, color: Colors.grey.shade700),
                  const SizedBox(width: 6),
                  Text(
                    "Chia sẻ",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLoadingComments)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ))
        else if (comments.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Chưa có bình luận nào",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          )
        else
          ...comments.map((comment) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: comment["avatar"] != null
                          ? NetworkImage(comment["avatar"])
                          : null,
                      child: comment["avatar"] == null
                          ? Image.asset("assets/illustration.png")
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment["user_name"] ?? "Người dùng",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment["content"] ?? "",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade200,
              child:
                  Image.asset("assets/illustration.png", width: 20, height: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: "Viết bình luận...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onSubmitted: (_) => _submitComment(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _submitComment,
            ),
          ],
        ),
      ],
    );
  }
}

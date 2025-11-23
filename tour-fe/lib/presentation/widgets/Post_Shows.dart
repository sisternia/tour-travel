// lib/presentation/widgets/Post_Shows.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_fe/data/models/profile_model.dart';
import 'package:video_player/video_player.dart';
import 'package:tour_fe/presentation/widgets/Image_Post.dart';

class PostShows extends StatefulWidget {
  final ProfileModel profile;
  final String content;
  final DateTime createdAt;

  final String? privacy;

  final List<Map<String, dynamic>>? images;
  final Uint8List? videoBytes;

  final VoidCallback onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onPin;
  final VoidCallback? onTarget;

  const PostShows({
    super.key,
    required this.profile,
    required this.content,
    required this.createdAt,
    required this.onDelete,
    this.onEdit,
    this.onPin,
    this.onTarget,
    this.images,
    this.videoBytes,
    this.privacy = "public",
  });

  @override
  State<PostShows> createState() => _PostShowsState();
}

class _PostShowsState extends State<PostShows> {
  VideoPlayerController? _videoController;
  String? _videoTempUrl;

  @override
  void initState() {
    super.initState();

    if (widget.videoBytes != null) {
      final base64Str = base64Encode(widget.videoBytes!);
      _videoTempUrl = "data:video/mp4;base64,$base64Str";
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(_videoTempUrl!))
            ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
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

  PopupMenuItem<String> _popupItem(
    IconData icon,
    String label,
    String value, {
    Color iconColor = Colors.black87,
    Color textColor = Colors.black87,
  }) {
    return PopupMenuItem(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(width: 14),
          Text(label, style: TextStyle(fontSize: 15, color: textColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 10),
          Text(widget.content, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          if (widget.videoBytes != null) _buildVideoBox(),
          if (widget.videoBytes == null &&
              widget.images != null &&
              widget.images!.isNotEmpty)
            ImagePost(images: widget.images!),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildVideoBox() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return Container(
        height: 260,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _videoController!.value.isPlaying
                  ? _videoController!.pause()
                  : _videoController!.play();
            });
          },
          child: Icon(
            _videoController!.value.isPlaying
                ? Icons.pause_circle_filled
                : Icons.play_circle_fill,
            size: 60,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: widget.profile.avatar != null
              ? NetworkImage(widget.profile.avatar!)
              : null,
          child: widget.profile.avatar == null
              ? Image.asset("assets/illustration.png")
              : null,
        ),
        const SizedBox(width: 10),

        // NAME + TIME + PRIVACY ICON
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.profile.userName ?? "",
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

        // POPUP MENU (Pin, Edit, Delete, Target)
        PopupMenuButton<String>(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          offset: const Offset(0, 10),
          constraints: const BoxConstraints(minWidth: 260),
          onSelected: (value) {
            if (value == "delete") widget.onDelete();
            if (value == "pin" && widget.onPin != null) widget.onPin!();
            if (value == "edit" && widget.onEdit != null) widget.onEdit!();
            if (value == "target" && widget.onTarget != null) {
              widget.onTarget!();
            }
          },
          itemBuilder: (context) => [
            _popupItem(Icons.push_pin_outlined, "Ghim bài viết", "pin"),
            _popupItem(Icons.edit_outlined, "Chỉnh sửa bài viết", "edit"),
            _popupItem(
                Icons.settings_outlined, "Chỉnh sửa đối tượng", "target"),
            _popupItem(Icons.delete_outline, "Xóa bài viết", "delete",
                iconColor: Colors.red, textColor: Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(children: [
          Icon(Icons.thumb_up_alt_outlined, size: 20),
          SizedBox(width: 6),
          Text("Thích")
        ]),
        Row(children: [
          Icon(Icons.comment_outlined, size: 20),
          SizedBox(width: 6),
          Text("Bình luận")
        ]),
        Row(children: [
          Icon(Icons.share_outlined, size: 20),
          SizedBox(width: 6),
          Text("Chia sẻ")
        ]),
      ],
    );
  }
}

// lib/presentation/screens/post/post_modal_screen.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tour_fe/data/models/profile_model.dart';
import 'package:tour_fe/presentation/widgets/Image_Post.dart';

class PostModal extends StatefulWidget {
  final ProfileModel profile;
  final Function(
      String content, List<Map<String, dynamic>> images, String privacy) onPost;

  final String? initialContent;
  final List<Map<String, dynamic>>? initialImages;
  final String initialPrivacy;

  const PostModal({
    super.key,
    required this.profile,
    required this.onPost,
    this.initialContent,
    this.initialImages,
    this.initialPrivacy = "public",
  });

  @override
  State<PostModal> createState() => _PostModalState();
}

class _PostModalState extends State<PostModal> {
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> selectedImages = [];
  String privacy = "public";

  @override
  void initState() {
    super.initState();

    privacy = widget.initialPrivacy;

    if (widget.initialContent != null) {
      _contentController.text = widget.initialContent!;
    }

    if (widget.initialImages != null) {
      selectedImages = List<Map<String, dynamic>>.from(widget.initialImages!);
    }
  }

  Future<void> pickImages() async {
    final imgs = await _picker.pickMultiImage();
    if (imgs.isEmpty) return;

    for (var img in imgs) {
      Uint8List bytes = await img.readAsBytes();
      selectedImages.add({
        "bytes": bytes,
        "isVertical": await _detectVertical(img),
      });
    }

    setState(() {});
  }

  Future<bool> _detectVertical(XFile file) async {
    Uint8List bytes = await file.readAsBytes();
    final image = await decodeImageFromList(bytes);
    return image.height > image.width;
  }

  IconData _privacyIcon() {
    switch (privacy) {
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

  String _privacyText() {
    switch (privacy) {
      case "public":
        return "Công khai";
      case "friends":
        return "Bạn bè";
      case "only_me":
        return "Chỉ mình tôi";
      case "custom":
        return "Tùy chỉnh";
    }
    return "Công khai";
  }

  PopupMenuItem<String> _privacyItem(
      String value, IconData icon, String label) {
    return PopupMenuItem(
      value: value,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatar = widget.profile.avatar;

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Material(
        color: Colors.black.withOpacity(0.35),
        child: Center(
          child: Container(
            width: 500,
            constraints: const BoxConstraints(maxWidth: 550, maxHeight: 550),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.hardEdge,
            child: GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  _buildAppBar(),
                  _buildUserHeader(avatar),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTextField(),
                          if (selectedImages.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: ImagePost(images: selectedImages),
                            ),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomBar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    final isEdit =
        widget.initialContent != null || widget.initialImages != null;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      title: Text(
        isEdit ? "Chỉnh sửa bài viết" : "Tạo bài viết",
        style: const TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {
            widget.onPost(
              _contentController.text.trim(),
              selectedImages,
              privacy,
            );
            Navigator.pop(context);
          },
          child: Text(
            isEdit ? "Lưu" : "Đăng",
            style: const TextStyle(
                fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        )
      ],
      leading: IconButton(
        icon: const Icon(Icons.close, size: 26, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildUserHeader(String? avatar) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: avatar != null ? NetworkImage(avatar) : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.profile.userName ?? "",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
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
                  setState(() => privacy = value);
                },
                itemBuilder: (context) => [
                  _privacyItem("public", Icons.public, "Công khai"),
                  _privacyItem("friends", Icons.group, "Bạn bè"),
                  _privacyItem("only_me", Icons.lock, "Chỉ mình tôi"),
                  _privacyItem("custom", Icons.settings, "Tùy chỉnh"),
                ],
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(_privacyIcon(), size: 15),
                      const SizedBox(width: 6),
                      Text(_privacyText(),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_drop_down,
                          size: 18, color: Colors.black54),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _contentController,
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Bạn đang nghĩ gì?",
          hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Thêm vào bài viết của bạn",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: pickImages,
                child: const Icon(Icons.image, size: 26, color: Colors.green),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.tag_faces, size: 26, color: Colors.orange),
              const SizedBox(width: 14),
              const Icon(Icons.gif, size: 26, color: Colors.teal),
              const SizedBox(width: 14),
              const Icon(Icons.more_horiz, size: 26, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}

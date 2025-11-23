// lib\presentation\widgets\Image_Post.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePost extends StatelessWidget {
  final List<Map<String, dynamic>> images;

  const ImagePost({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    int vertical = images.where((e) => e["isVertical"] == true).length;
    int horizontal = images.length - vertical;

    if (horizontal >= vertical) return _layoutHorizontal(context);
    return _layoutVertical(context);
  }

  dynamic b(int i) => images[i];

  Widget renderedImage(dynamic img, {double? height}) {
    if (img["bytes"] != null) {
      return Image.memory(
        img["bytes"],
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        img["url"],
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  void _openViewer(BuildContext context, int index) {
    final controller = PageController(initialPage: index);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.90),
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return RawKeyboardListener(
              focusNode: FocusNode()..requestFocus(),
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut);
                } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                  controller.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut);
                }
              },
              child: Stack(
                children: [
                  PageView.builder(
                    controller: controller,
                    itemCount: images.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_, i) => Center(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4,
                        child: renderedImage(b(i), height: null),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black87,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _img(BuildContext context, dynamic img, int index, {double h = 150}) {
    return GestureDetector(
      onTap: () => _openViewer(context, index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: renderedImage(img, height: h),
      ),
    );
  }

  // ---------- Layout Horizontal ----------
  Widget _layoutHorizontal(BuildContext context) {
    final count = images.length;

    if (count == 1) return _img(context, b(0), 0, h: 330);

    if (count == 2) {
      return Row(children: [
        Expanded(child: _img(context, b(0), 0, h: 200)),
        const SizedBox(width: 6),
        Expanded(child: _img(context, b(1), 1, h: 200)),
      ]);
    }

    if (count == 3) {
      return Row(children: [
        Expanded(child: _img(context, b(0), 0, h: 260)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(children: [
            _img(context, b(1), 1, h: 127),
            const SizedBox(height: 6),
            _img(context, b(2), 2, h: 127),
          ]),
        ),
      ]);
    }

    if (count == 4) {
      return Column(children: [
        Row(children: [
          Expanded(child: _img(context, b(0), 0, h: 180)),
          const SizedBox(width: 6),
          Expanded(child: _img(context, b(1), 1, h: 180)),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: _img(context, b(2), 2, h: 180)),
          const SizedBox(width: 6),
          Expanded(child: _img(context, b(3), 3, h: 180)),
        ]),
      ]);
    }

    if (count == 5) {
      return Row(children: [
        Expanded(
          child: Column(children: [
            _img(context, b(0), 0, h: 127),
            const SizedBox(height: 6),
            _img(context, b(1), 1, h: 127),
          ]),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(children: [
            _img(context, b(2), 2, h: 82),
            const SizedBox(height: 6),
            _img(context, b(3), 3, h: 82),
            const SizedBox(height: 6),
            _img(context, b(4), 4, h: 82),
          ]),
        ),
      ]);
    }

    int extra = count - 5;

    return Row(children: [
      Expanded(
        child: Column(children: [
          _img(context, b(0), 0, h: 127),
          const SizedBox(height: 6),
          _img(context, b(1), 1, h: 127),
        ]),
      ),
      const SizedBox(width: 6),
      Expanded(
        child: Column(children: [
          _img(context, b(2), 2, h: 82),
          const SizedBox(height: 6),
          _img(context, b(3), 3, h: 82),
          const SizedBox(height: 6),
          Stack(children: [
            _img(context, b(4), 4, h: 82),
            Container(
              height: 82,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.55),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text("+$extra",
                  style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            )
          ]),
        ]),
      )
    ]);
  }

  // ---------- Layout Vertical ----------
  Widget _layoutVertical(BuildContext context) {
    final count = images.length;

    if (count == 1) return _img(context, b(0), 0, h: 430);

    if (count == 2) {
      return Row(children: [
        Expanded(child: _img(context, b(0), 0, h: 250)),
        const SizedBox(width: 6),
        Expanded(child: _img(context, b(1), 1, h: 250)),
      ]);
    }

    if (count == 3) {
      return Column(children: [
        Row(children: [
          Expanded(child: _img(context, b(0), 0, h: 230)),
          const SizedBox(width: 6),
          Expanded(child: _img(context, b(1), 1, h: 230)),
        ]),
        const SizedBox(height: 6),
        _img(context, b(2), 2, h: 230),
      ]);
    }

    if (count == 4) {
      return Column(children: [
        Row(children: [
          Expanded(child: _img(context, b(0), 0, h: 230)),
          const SizedBox(width: 6),
          Expanded(child: _img(context, b(1), 1, h: 230)),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: _img(context, b(2), 2, h: 230)),
          const SizedBox(width: 6),
          Expanded(child: _img(context, b(3), 3, h: 230)),
        ]),
      ]);
    }

    if (count == 5) {
      return Column(children: [
        Row(children: [
          Expanded(child: _img(context, b(0), 0, h: 230)),
          const SizedBox(width: 6),
          Expanded(child: _img(context, b(1), 1, h: 230)),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: _img(context, b(2), 2, h: 180)),
          const SizedBox(width: 6),
          Expanded(child: _img(context, b(3), 3, h: 180)),
          const SizedBox(width: 6),
          Expanded(child: _img(context, b(4), 4, h: 180)),
        ]),
      ]);
    }

    int extra = count - 5;

    return Column(children: [
      Row(children: [
        Expanded(child: _img(context, b(0), 0, h: 230)),
        const SizedBox(width: 6),
        Expanded(child: _img(context, b(1), 1, h: 230)),
      ]),
      const SizedBox(height: 6),
      Row(children: [
        Expanded(child: _img(context, b(2), 2, h: 180)),
        const SizedBox(width: 6),
        Expanded(child: _img(context, b(3), 3, h: 180)),
        const SizedBox(width: 6),
        Expanded(
          child: Stack(children: [
            _img(context, b(4), 4, h: 180),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text("+$extra",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
            ),
          ]),
        ),
      ]),
    ]);
  }
}

// lib/presentation/widgets/Sliding_Form.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SlidingForm extends StatefulWidget {
  final Widget child;
  final double formHeight;

  const SlidingForm({
    super.key,
    required this.child,
    required this.formHeight,
  });

  @override
  State<SlidingForm> createState() => _SlidingFormState();
}

class _SlidingFormState extends State<SlidingForm> {
  late double _top;
  late double _collapsed;
  late double _expanded;

  bool _expandedState = true; // 🔥 mở sẵn khi load
  double _dragStart = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final h = MediaQuery.of(context).size.height;

    _expanded = h - widget.formHeight;
    _collapsed = h - 60;

    /// 🔥 FORM TỰ MỞ NGAY BAN ĐẦU
    _expandedState = true;
    _top = _expanded;
  }

  void _toggle() {
    setState(() {
      _expandedState = !_expandedState;
      _top = _expandedState ? _expanded : _collapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      left: 0,
      right: 0,
      top: _top,
      height: widget.formHeight,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragStart: (d) => _dragStart = _top,
        onVerticalDragUpdate: (d) {
          setState(() {
            _top = (_dragStart + d.delta.dy).clamp(_expanded, _collapsed);
          });
        },
        onVerticalDragEnd: (d) {
          final mid = (_expanded + _collapsed) / 2;
          final shouldExpand =
              d.primaryVelocity != null && d.primaryVelocity! < -150
                  ? true
                  : d.primaryVelocity != null && d.primaryVelocity! > 150
                      ? false
                      : _top < mid;

          setState(() {
            _expandedState = shouldExpand;
            _top = shouldExpand ? _expanded : _collapsed;
          });
        },
        onTap: () {
          if (kIsWeb ||
              Theme.of(context).platform == TargetPlatform.windows ||
              Theme.of(context).platform == TargetPlatform.macOS ||
              Theme.of(context).platform == TargetPlatform.linux) {
            _toggle();
          }
        },
        child: Column(
          children: [
            const SizedBox(height: 4),

            /// Handle tròn
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                  )
                ],
              ),
              child: const Icon(Icons.reorder, color: Colors.black87),
            ),

            Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _expandedState ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !_expandedState,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(28)),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

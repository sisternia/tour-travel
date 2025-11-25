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

  bool _expandedState = false;
  double _dragStart = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final h = MediaQuery.of(context).size.height;

    _collapsed = h;
    _expanded = h - 40;

    _top = _collapsed;
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
      duration: const Duration(milliseconds: 240),
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
            _top = (_dragStart + d.delta.dy)
                .clamp(_expanded - 30, _collapsed + 30);
          });
        },
        onVerticalDragEnd: (d) {
          final mid = (_collapsed + _expanded) / 2;

          final shouldExpand =
              d.primaryVelocity != null && d.primaryVelocity! > 150
                  ? true
                  : d.primaryVelocity != null && d.primaryVelocity! < -150
                      ? false
                      : _top > mid;

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
            Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.45),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.reorder, color: Colors.black87),
            ),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}
